action :create do
  ruby_block "create jks keystore" do
    block do
      require "open3"
      require "pp"
      list_keys_command = "keytool -list -storepass changeit -keystore \
                          #{ENV['JAVA_HOME']}/jre/lib/security/cacerts | \
                          tail -n +6 | grep -v '^Certificate fingerprint' | \
                          awk -F, '{print $1}'"
      Open3.popen3(list_keys_command) do |stdin, stdout, stderr, wait_thr|
        stdout.read.split("\n").each do |string|
          pp string
        end
      end
    end
    action :create
  end
end
