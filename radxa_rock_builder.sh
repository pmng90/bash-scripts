#!/bin/bash
#~ 
#~ ----------------------------------------------------------------------------------------------------------------
#~ -------------------------------DEFAULT PATHS--------------------------------------------------------------------
# Update.img "/home/$USER/home/romsource_Folder/rockdev/update.img" 
#~Kernel.img "/home/$USER/home/romsource_Folder/kernel/"
#~Flash_tool_Utility "/home/$USER/home/romsource_Folder/RKTools/linux/Linux_Upgrade_Tool_v1.16/"
#~ -------------------------------DEFAULT PATHS--------------------------------------------------------------------
#~ 
#~ 
#~ 
MASTER_PATH=$(dirname $(readlink -f $0) )
ROM_PATH=$MASTER_PATH;
KERNEL_PATH=$MASTER_PATH/kernel
RKTOOLS_PATH=$MASTER_PATH/RKTools/linux/Linux_Upgrade_Tool_v1.16
IMG_PATH=$MASTER_PATH/rockdev;

filechecker()
{ 
	if [ ! -d "$KERNEL_PATH" -o ! -d "$IMG_PATH" ] ;then 
		if [ ! -d "$RKTOOLS" ] ; then
	
			  echo "ERROR:Path To Kernel not Found";
			   echo "ERROR:PATH To Image Not Found";
			    echo "ERROR:Path To Flash Tools Not Found";
					exit;
		fi
	fi	
}

#~ ##<<<<Kernel section>>>>## 


ker ()
{

				cd $KERNEL_PATH;
				echo "we are going to make a kernel!!"
				
				while :
				do
				
				echo "whats happening??"
				echo "1. make mr.proper"
				echo "2. make clean"
				echo "3. build the android 4.2 jb image for radxa rock "
				echo "4. build the android 4.4 kk image for radxa rock"
				echo "5. build the android 4.4 kk image for radxa rock pro[hdmi]"
				echo "6. build the android 4.4 kk image for radxa rock pro[lvds]"
				echo "7. make menucongig"
				echo "8. make xconfig"
				echo "9. make kenel"
				echo "10. Go Back"
				echo -n "please enter option [1 - 10]"
				read opt
				case $opt in
						1) echo "make mr.proper";
						make mrproper;;
						2) echo "make clean";
						make clean;;
						3) echo "building jelly rock kernel";
						make rk3188_radxa_rock_defconfig;;
						4) echo "building rock kernel";
						make rk3188_radxa_rock_kitkat_defconfig;;
						5) echo "building rock pro[hdmi] kernel";
						make rk3188_box_radxa_rock_pro_hdmi_defconfig;;
						6) echo "building rock pro[lvds] kernel";
						rk3188_box_radxa_rock_pro_lvds_defconfig;;
						7) echo "loading menucongig";
						make menuconfig;;
						8) echo "preparing xconfig";
						make xconfig;;
						9) echo "making kenel";
						make kernel.img;;
						10) echo "kudos";
						main
						;;
						*) echo "$opt is an invaild option. please select option between 1-4 only";
						echo "press [enter] key to continue. . .";
						read enterkey;;
				esac
				done

}

##<<<<Rom section>>>>##  

rom ()
{			cd $ROM_PATH
while :
do
			
			source $ROM_PATH/build/envsetup.sh
			echo $ROM_PATH/build/envsetup.sh
			echo "NOTE:PLEASE BUILD KERNEL FIRST[IGNORE IF DONE]"
			echo "1. Make Clobber"
			echo "2. Make Clean"
			echo "3. Build the android 4.4.2 radxa rock "
			echo "4. Build the android 4.4.2 KK image for radxa rock pro"
			echo "5. Make -j4"
			echo "6. convert the files to Image"
			echo "7. Go Back to Main Menu"
			echo -n "Please enter option [1 - 7]"
			read opt
			case $opt in
					1) echo "Clobbering....";
					make clobber;;
					2) echo "Cleaning";
					make clean;;
					3) echo "Building Rock";
					lunch radxa_rock-eng;
					echo "Building Finished..................";;
					4) echo "Building Rock pro...";
					lunch radxa_rock_pro-eng;
					echo "Building Finished..................";;
					5) echo "Let the fun Begin..";
					make -j4;;
					6) echo "I see.. U like the Update.img.. wait a bit mate!!!";
					./mkimage.sh ota;;
					7) echo "I see.. U like the Update.img.. wait a bit mate!!!";
					main
					;;
					*) echo "$opt is an invaild option. Please select option between 1-4 only";
					echo "Press [enter] key to continue. . .";
					read enterKey;;
			esac
done
		
}

##<<<<Rom Flashing>>>>##
flash ()
{
	cd $RKTOOLS_PATH;
		
		while :
		do
			
			echo "What will it be??"
			echo "1. Low Level Format"
			echo "2. Flash the Fresh Brew [Update.img]??"
			echo "3. Flash Something Else [Drag and Drop that Image] "
			echo "4. Back "
			
			echo 
			read -p "Please enter option [1 - 4]  " opt
			case $opt in
			1) echo "Let it go, Let it die";
			sudo ./upgrade_tool lf ;
			;;
			2) echo "Push Damn It!!PUSH";
			sudo ./upgrade_tool uf $IMG_PATH/update.img; 
			;; 
			3) echo "Drag and drop the relevant img file";
			read custom;
			sudo ./upgrade_tool uf "${custom//\'}"  ;
			;; 
			4) echo "Kudos";
			main
			;;
			*) echo "$opt is an invaild option. Please select option between 1-4 only";
			echo "Press [enter] key to continue. . .";
			read enterKey;;
		esac
		done
	
	}

##<<<<Utilities section >>>>##	
utils()
{
while :
				do
				
				echo "1. Install JDK 1.6"
				echo "2. Configure default Java Compiler"
				echo "3. Install ADB && FastBoot "
				echo "4. Required Packages for Ubuntu 12.xx"
				echo "5. Required Packages for Ubuntu 13.xx && 14.xx"
				echo "6. ARM Toolchain"
				echo "7. Install Some Supporting Libraries"
				echo "8.Go Back"
				echo -n "Please enter option [1 - 8]"
				read opt
				case $opt in
						1) echo "JDK";
						sudo add-apt-repository ppa:webupd8team/java &&
						 sudo apt-get update &&
						 sudo apt-get install oracle-java6-installer
						 ;;
						2) echo "Configure Java";
						sudo update-alternatives --config javac;;
						
						3) echo "Install ADB And Fastboot";
						sudo apt-get install android-tools-adb android-tools-fastboot;;
						4) echo "Packages for Ubuntu 12.xx";
						sudo apt-get install git gnupg flex bison gperf build-essential \
						   zip curl libc6-dev libncurses5-dev:i386 x11proto-core-dev \
						   libx11-dev:i386 libreadline6-dev:i386 libgl1-mesa-glx:i386 \
						   g++-multilib mingw32 tofrodos gcc-multilib ia32-libs\
						   python-markdown libxml2-utils xsltproc zlib1g-dev:i386;;
						5) echo "Required Packages for Ubuntu 13.xx && 14.xx";
						sudo apt-get install git-core gnupg flex bison gperf libsdl1.2-dev\
						   libesd0-dev libwxgtk2.8-dev squashfs-tools build-essential zip curl\
						   libncurses5-dev zlib1g-dev pngcrush schedtool libxml2 libxml2-utils\
						   xsltproc lzop libc6-dev schedtool g++-multilib lib32z1-dev lib32ncurses5-dev\
						   lib32readline-gplv2-dev gcc-multilib libswitch-perl;;
						6) echo "ARM Toolchain";
						sudo apt-get install gcc-arm-linux-gnueabihf &&
							sudo apt-get install lzop libncurses5-dev;;
						7) echo "Supporting Libraries";
						sudo apt-get install libssl1.0.0 libssl-dev;;
						8) echo "Ba Bye";
						main
						;;
						*) echo "$opt is an invaild option. please select option between 1-4 only";
						echo "press [enter] key to continue. . .";
						read enterkey;;
				esac
				done
}
main()
{			
	cd $MASTER_PATH;
			filechecker
			while :
			do
				clear
				echo "What will it be??"
				echo "1. Build Kernel"
				echo "2. Build Rom"
				echo "3. Flash the Rom(update.img)"
				echo "4. Utilities"
				echo "5. Exit"
				echo -n "Please enter option [1 - 5]"
				read opt
				case $opt in
				
				1) echo "kernel";
				ker
				;;
				2) echo "Rom";
				rom
				;;
				3) echo "Flashing";
				flash
				;;
				4) echo "Opening Back-Door"
				utils
				;;
				
		 5) echo "Kudos";
		 exit;;
				 *) echo "$opt is an invaild option. Please select option between 1-4 only";
				 echo "Press [enter] key to continue. . .";
				 read enterKey;;
				 esac
			done;

}
main; 

