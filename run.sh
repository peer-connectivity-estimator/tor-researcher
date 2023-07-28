#gnome-terminal -- bash -c "./src/app/tor ; exec bash"
now=$(date +'%m-%d-%y-%H-%M')
./src/app/tor --ClientOnly 1 --UseEntryGuards 0 --Log "[circ]info file ~/Desktop/tor-${now}.log"
