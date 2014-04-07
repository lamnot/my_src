	SDFat library for the Olimexino STM32
	  (!) Depends on an Ethernet Library,
		  which is also included in this archive
		  
	Works with the Maple IDE (currently 0012)
			  + OlimexinoSTM32
			  + a MicroSD card formatted as FAT/FAT32

	To install the libraries, copy the two folders to 
	the /libraries/ folder in your Maple IDE installation
	folder.
	
	The examples we tried with OlimexinoSTM32 :
	-- FileSys - shows several errors
			   - The error "Invalid partition"
			     appears several times in other examples, with both
				 FAT and FAT32; those examples, however, work fine
	-- SDFat Info - OK
	-- SDFat Bench - OK, Write ~90kb/s
						 Read  ~180kb/s
	-- SDFat Timestamp - OK
	-- SDFat Append - OK
	-- SDFatLS - OK
	-- SDFat MakeDir - OK
	-- SDFat Write - OK
	-- SDFat Read - OK
	-- SDFat Remove Dir - OK
	-- SDFat Tail - OK
	-- SDFat Truncate - OK
	-- CardInfo - OK
				 
	Those libraries were taken from:
	http://forums.leaflabs.com/topic.php?id=2043
	
	where the user 'dinau' supplied the links to the projects:
	/* post */
	
		Hi all,

		I modified maple-sdfat library a few months ago.
		It can be complied and executed almost examples.
	
		Please read below overview page for SdFatMaple-vld.
		https://bitbucket.org/dinau/sdfatmaple-vld/overview
		 You need download below two libraries.
		https://bitbucket.org/dinau/sdfatmaple-vld/downloads/sdfat-maple-vld-v02-20120325.zip
		https://bitbucket.org/dinau/ethernetmaple/downloads/EthernetMaple_v02_201207.zip

		dinau
		
	/* post */

	If you have any questions, visit the leaflabs forum at:
	http://forums.leaflabs.com
	
	or email
	support@olimex.com
	
	July, 2012