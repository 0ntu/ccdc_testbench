Vagrant.configure("2") do |config|
  # config.vm.box = "generic/ubuntu2204"
  config.vm.box = "centos/7"

  # Provision with a shell script
  config.vm.provision "shell", inline: <<-SHELL
    # Usernames taken from xato_net_usernames wordlist
    innocuous_users=( "derek" "chan" "buffalo" "tim" "qwert" "phillip" "movie" "jester" "donnie" "clinton" "sam" "harrison" "bishop" "toyota" "gateway" "cool" "cherry" "candy" "bigguy" "bernie" "ben" "robin" "duke" "brent" "american" "alberto" "alberta" "smith" "raider" "princess" "magic" "homer" "reddog" "lawrence" "ladies" "jerome" "flipper" "drew" "arnold" "apple" "allen" "tomcat" "song" "parker" "latin" "julian" )
    password="password"

    # Create users
    for user in "${innocuous_users[@]}"; do
      sudo useradd -c "User Account" -m -p "$password" -s "/bin/bash" $user
    done
  SHELL
end
