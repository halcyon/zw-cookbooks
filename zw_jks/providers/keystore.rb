action :create do
  package "jdk" do
    case node[:platform]
    when "redhat"
      package_name "java-1.6.0-openjdk-devel"
    when "ubuntu"
      package_name "openjdk-6-jdk"
    end
    action :install
  end
  ruby_block "create jks keystore" do
    block do
      require 'net/http'
      require 'net/https'
      require 'uri'
      require 'open3'

      SUBJECT = new_resource.subject
      CN_ALIAS = new_resource.cn_alias
      CA_URL = new_resource.ca_url
      CA_USER = new_resource.ca_user
      CA_PASS = new_resource.ca_pass
      STORE_PASS = new_resource.store_pass
      USER_AGENT = new_resource.user_agent

      def popen3(cmd, options={})
        Open3.popen3(cmd) do | stdin, stdout, stderr, wait_thr|
          if options[:stdin] != nil then
            stdin.puts(options[:stdin])
            stdin.close
          end
          @out=stdout.read
          @err=stderr.read
          if options[:silent] != true then
            if options[:stderr] != true then
              if ! @out.empty? then
                puts "stdout: #{@out}"
              end
            end
            if ! @err.empty? then
              puts "stderr: #{@err}"
            end
          end
        end
        return [@out, @err]
      end

      def set_java_home()
        alternatives_java_cmd = "update-alternatives --display javac"
        java_alternatives = popen3 alternatives_java_cmd, :silent => true
        java_alternatives[0].each do |line|
          if ! line.scan(/link currently points to (.*)\/bin/).empty?
            ENV['JAVA_HOME'] = line.scan(/link currently points to (.*)\/bin/).to_s
          end
        end
      end


      def gen_keypair()
        if not ::File::exists? "/keystore.jks"
          keypair_cmd = "keytool -keypass #{STORE_PASS} -alias #{CN_ALIAS} \
                    -keyalg rsa -genkeypair -dname \"#{SUBJECT}\" -keystore keystore.jks -storepass #{STORE_PASS}"
          popen3(keypair_cmd,{:stderr => true})
        end
      end


      def add_default_certs()
        list_src_keys_cmd = "keytool -list -storepass changeit -keystore \
                             #{ENV['JAVA_HOME']}/jre/lib/security/cacerts | \
                             tail -n +7 | grep -v '^Certificate fingerprint' | \
                             awk -F, '{print $1}'"

        list_dest_keys_cmd = "keytool -list -storepass #{STORE_PASS} -keystore \
                              /keystore.jks | \
                              tail -n +7 | grep -v '^Certificate fingerprint' | \
                              awk -F, '{print $1}'"


        xfer_cert_cmd = 'keytool -export -alias #{cert} -storepass changeit \
                         -keystore #{ENV[\'JAVA_HOME\']}/jre/lib/security/cacerts | \
                         keytool -import -alias #{cert} -trustcacerts -noprompt \
                         -storepass #{STORE_PASS} -keystore keystore.jks'

        src_cert_names = popen3(list_src_keys_cmd,:stderr => true)[0].split("\n")
        dest_cert_names = popen3(list_dest_keys_cmd, :stderr => true)[0].split("\n")
        src_cert_names.each do |cert|
          if dest_cert_names.include? cert
          else
            popen3(eval("\"#{xfer_cert_cmd}\""),{:stderr => true})
          end
        end
      end

      def add_ca_cert()
        list_dest_keys_cmd = "keytool -list -storepass #{STORE_PASS} -keystore \
                              /keystore.jks | \
                              tail -n +7 | grep -v '^Certificate fingerprint' | \
                              awk -F, '{print $1}'"

        import_ca_cert ='keytool -import -alias #{uri.host.split(\'.\')[0]} \
                        -trustcacerts -noprompt -storepass #{STORE_PASS} \
                        -keystore keystore.jks'

        dest_cert_names = popen3(list_dest_keys_cmd, :stderr => true)[0].split("\n")

        uri = URI.parse(CA_URL)

        if ! dest_cert_names.include? uri.host.split('.')[0]
          http=Net::HTTP.new(uri.host,uri.port)
          http.use_ssl = true
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE

          request = Net::HTTP::Get.new(uri.request_uri+"certnew.cer?ReqID=CACert&Renewal=0&Enc=b64", {"User-Agent" => USER_AGENT})
          request.basic_auth CA_USER, CA_PASS
          response = http.request(request)
          cert=response.body
          popen3(eval("\"#{import_ca_cert}\""),{:stdin => cert, :stderr => true})
        end
      end

      def gen_csr()
        csr_cmd = "keytool -certreq -alias #{CN_ALIAS} -noprompt -storepass #{STORE_PASS} -keystore keystore.jks"
        out, err = popen3(csr_cmd, {:stderr => true})
        csr = out
        csr
      end

      def sign_csr(csr)
        uri = URI.parse(CA_URL+"/certfnsh.asp")
        http=Net::HTTP.new(uri.host,uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        request = Net::HTTP::Post.new(uri.request_uri, {"User-Agent" => USER_AGENT})
        request.basic_auth CA_USER, CA_PASS
        request.set_form_data({"Mode" => "newreq", "CertRequest" => csr})
        response = http.request(request)
        if (response.code.to_i != 200) then
          puts "Error issuing cert"
        end
        response.body.scan(/location="certnew.cer\?ReqID=([0-9]+)\&"\+getEncoding\(\)\;/).to_s
      end

      def get_cert(req_id)
        uri = URI.parse(CA_URL+"/certnew.cer")
        http=Net::HTTP.new(uri.host,uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        request = Net::HTTP::Get.new(uri.request_uri+"?ReqID=#{req_id}&Enc=b64", {"User-Agent" => USER_AGENT})
        request.basic_auth CA_USER, CA_PASS
        response = http.request(request)
        response.body
      end


      def import_cert(cert)
        import_cert = "keytool -import -alias #{CN_ALIAS} -noprompt -storepass #{STORE_PASS} -keystore keystore.jks"
        popen3(import_cert,{:stdin => cert, :stderr => true})

        #Create apache key
        file = ::File.new("server.key", "w")
        file.write(cert)
        file.close
      end

      set_java_home
      gen_keypair
      add_default_certs
      add_ca_cert
      import_cert(get_cert(sign_csr(gen_csr)))
    end
    action :create
  end
end
