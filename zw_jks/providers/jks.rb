action :create do
  ruby_block "create jks keystore" do
    block do
      require "open3"
      require "pp"

      list_keys_command = "keytool -list -storepass changeit -keystore \
                          #{ENV['JAVA_HOME']}/jre/lib/security/cacerts | \
                          tail -n +7 | grep -v '^Certificate fingerprint' | \
                          awk -F, '{print $1}'"


      xfer_cert_command = 'keytool -export -alias #{cert} -storepass changeit \
                          -keystore #{ENV[\'JAVA_HOME\']}/jre/lib/security/cacerts | \
                          keytool -import -alias #{cert} -trustcacerts -noprompt \
                          -storepass changeit -keystore keystore.jks'

      xfer = 'This is a #{cert} and a #{ENV["JAVA_HOME"]}'


      Open3.popen3(list_keys_command) do |stdin, stdout, stderr, wait_thr|

        @cert_names = stdout.read.split("\n")
      end

      @cert_names.each do |cert|
        Open3.popen3(eval("\"#{xfer_cert_command}\"")) do |stdin, stdout, stderr, wait_thr|
          out=stdout.read
          err=stderr.read
          if ! out.empty? then
            puts out
          end
          if ! err.empty? then
            puts err
          end
        end
      end
    end
    action :create
  end
end
