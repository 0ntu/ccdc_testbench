Vagrant.configure("2") do |config|
  # Specify the Ubuntu box
  config.vm.box = "generic/ubuntu2204" # Change to the Ubuntu version you need

  # Provision with a shell script
  config.vm.provision "shell", inline: <<-SHELL
    # Usernames taken from xato_net_usernames wordlist
    innocuous_users=( "derek" "chan" "buffalo" "tim" "qwert" "phillip" "movie" "jester" "donnie" "clinton" "sam" "harrison" "bishop" "toyota" "gateway" "cool" "cherry" "candy" "bigguy" "bernie" "ben" "robin" "duke" "brent" "american" "alberto" "alberta" "smith" "raider" "princess" "magic" "homer" "reddog" "lawrence" "ladies" "jerome" "flipper" "drew" "arnold" "apple" "allen" "tomcat" "song" "parker" "latin" "julian" )
    password="password"

    # Create users
    for user in "${innocuous_users[@]}"; do
      sudo adduser --disabled-password --gecos "" $user
      echo "$user:$password" | sudo chpasswd
    done
  SHELL
end
