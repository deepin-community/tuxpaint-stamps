-- TuxPaint Stamps Installer.applescript
-- TuxPaint Stamps Installer

--  Created by Martin Fuhrer on 09/11/04.
--  Copyright (c) 2004-2021 TuxPaint Devlopment Team. All rights reserved.

property stampsLocation : 1
property installStamps : true
property asRoot : false
property archiveName : "tuxpaint-stamps"

on open names
	(* Add your script to process the names here. *)

	-- Remove the following line if you want the application to stay open.
	quit
end open

(* Deal with the click event on buttons *)
on clicked theObject
	if the name of theObject is "btnInstall" then
		set installStamps to true
		if stampsLocation is 1 then
			set pathName to (system attribute "HOME") & "/Library/Application Support/TuxPaint"
			set asRoot to false
			install(pathName)
		else if stampsLocation is 2 then
			set pathName to "/Library/Application Support/TuxPaint"
			set asRoot to true
			install(pathName)
		else if stampsLocation is 3 then
			chooseTuxPaintApplication()
		end if
	else if the name of theObject is "btnRemove" then
		set installStamps to false
		if stampsLocation is 1 then
			set pathName to (system attribute "HOME") & "/Library/Application Support/TuxPaint"
			set asRoot to false
			uninstall(pathName)
		else if stampsLocation is 2 then
			set pathName to "/Library/Application Support/TuxPaint"
			set asRoot to true
			uninstall(pathName)
		else if stampsLocation is 3 then
			chooseTuxPaintApplication()
		end if
	else if the name of theObject is "btnQuit" then
		quit
	else if the name of theObject is "radCurrent" then
		set stampsLocation to 1
	else if the name of theObject is "radAll" then
		set stampsLocation to 2
	else if the name of theObject is "radApplication" then
		set stampsLocation to 3
	end if
	updateStatus()
end clicked

on panel ended theObject with result withResult
	set title of window "winInstaller" to "Tux Paint Stamps Installer"
	if withResult is 1 then
		set pathNames to (path names of open panel as list)
		set pathName to first item of pathNames

		-- check that a valid Tux Paint application was selected
		set binary to pathName & "/Contents/MacOS/TuxPaint"
		set commandOne to "test -f " & quoted form of binary

		set binary to pathName & "/Contents/MacOS/Tux Paint"
		set commandTwo to "test -f " & quoted form of binary

		set binary to pathName & "/tuxpaint"
		set commandThree to "test -f " & quoted form of binary

		set validApp to false
		try
			set myResult to do shell script commandOne
			set validApp to true
			set pathName to pathName & "/Contents/Resources"
		on error errorText number errorNumber
		end try

		try
			set myResult to do shell script commandTwo
			set validApp to true
			set pathName to pathName & "/Contents/Resources"
		on error errorText number errorNumber
		end try

		try
			set myResult to do shell script commandThree
			set validApp to true
		on error errorText number errorNumber
		end try

		if validApp is true then
			if installStamps is true then
				install(pathName)
			else
				set stampsPath to pathName & "/stamps"
				try
					set stampsAlias to alias (POSIX file stampsPath)
					uninstall(pathName)
				on error
					display dialog "No stamps were found in the Tux Paint application." buttons {"OK"} default button 1 with icon 1
				end try
			end if
		else
			display dialog "Sorry, the application you selected does not appear to be Tux Paint!" buttons {"OK"} default button 1 with icon 1
		end if
	end if
end panel ended

on will close theObject
	if the name of theObject is "winInstaller" then
		quit
	end if
end will close

on activated theObject
	updateStatus()
end activated

on install(pathName)
	set problem to false
	set enabled of button "btnInstall" of window "winInstaller" to false
	--display panel window "pnlUpdate"

	-- remove any pre-existing stamps directory
	uninstall(pathName)

	-- create new stamps directory
	set command to "mkdir -p " & quoted form of pathName
	try
		if asRoot is true then
		    do shell script command with administrator privileges
		else
		    do shell script command
		end if
	on error
		set problem to true
	end try

	-- extract stamps archive
	set myPath to path to me as string
	set archivePath to myPath & "Contents:Resources:" & archiveName & ".tar.gz" as string
	set archivePath to POSIX path of archivePath

	set command to "tar -zxf " & quoted form of archivePath
	set command to command & " -C " & quoted form of pathName
	try
		if asRoot is true then
			do shell script command with administrator privileges
		else
			do shell script command
		end if
	on error
		set problem to true
	end try

	-- create file with stamps version
	set versionPath to pathName & "/stamps/version"
	set command to "echo " & stampsInstallerVersion() & " > " & quoted form of versionPath
	try
		if asRoot is true then
			do shell script command with administrator privileges
		else
			do shell script command
		end if
	end try

	--close panel window "pnlUpdate"
	if problem is false then
		display dialog "Tux Paint stamps have been successfully installed!" buttons {"OK"} default button 1 with icon 2
	else
		display dialog "Sorry, Tux Paint stamps could not be installed." buttons {"OK"} default button 1 with icon 1
	end if

	set enabled of button "btnInstall" of window "winInstaller" to true
end install

on uninstall(pathName)
	set problem to false

	set oldStamps to quoted form of (pathName & "/stamps")
	set command to "rm -r " & oldStamps
	try
		if asRoot is true then
			do shell script command with administrator privileges
		else
			do shell script command
		end if
	on error errorText number errorNumber
		set problem to true
	end try

	if installStamps is false then
		if problem is false then
			display dialog "Tux Paint stamps have been successfully removed!" buttons {"OK"} default button 1 with icon 1
		else
			display dialog "Sorry, Tux Paint stamps could not be removed." buttons {"OK"} default button 1 with icon 1
		end if
	end if
end uninstall

on updateStatus()
	set currentUserStampsInstalled to false
	set stampsPath to (system attribute "HOME") & "/Library/Application Support/TuxPaint/stamps"
	try
		set stampsAlias to alias (POSIX file stampsPath)
		set versionString to installedStampsFuzzyVersion(stampsPath)

		set title of cell "radCurrent" of matrix "matLocation" of window "winInstaller" to "Current User (" & versionString & " installed)"
		set currentUserStampsInstalled to true
	on error
		set title of cell "radCurrent" of matrix "matLocation" of window "winInstaller" to "Current User"
	end try

	set allUsersStampsInstalled to false
	set stampsPath to "/Library/Application Support/TuxPaint/stamps"
	try
		set stampsAlias to alias (POSIX file stampsPath)
		set versionString to installedStampsFuzzyVersion(stampsPath)
		set title of cell "radAll" of matrix "matLocation" of window "winInstaller" to "All Users (" & versionString & " installed)"
		set allUsersStampsInstalled to true
	on error
		set title of cell "radAll" of matrix "matLocation" of window "winInstaller" to "All Users"
	end try

	if stampsLocation is 1 then
		if currentUserStampsInstalled is true then
			set enabled of button "btnRemove" of window "winInstaller" to true
		else
			set enabled of button "btnRemove" of window "winInstaller" to false
		end if
	else if stampsLocation is 2 then
		if allUsersStampsInstalled is true then
			set enabled of button "btnRemove" of window "winInstaller" to true
		else
			set enabled of button "btnRemove" of window "winInstaller" to false
		end if
	else if stampsLocation is 3 then
		set enabled of button "btnRemove" of window "winInstaller" to true
	end if
end updateStatus

on installedStampsFuzzyVersion(stampsPath)
	set versionString to installedStampsVersion(stampsPath)
	set appVersion to stampsInstallerVersion()

	if versionString is "0.0" then
		set versionString to "other version"
	else if versionString is appVersion then
		set versionString to "current version"
	else
		set versionString to "v." & versionString
	end if
	return versionString
end installedStampsFuzzyVersion

on installedStampsVersion(stampsPath)
	set versionPath to stampsPath & "/version"
	set installedVersion to "0.0"

	set command to "cat " & quoted form of versionPath
	try
		set installedVersion to do shell script command
	end try
	return installedVersion
end installedStampsVersion

on stampsInstallerVersion()
	set appBundle to call method "mainBundle" of class "NSBundle"
	set appVersion to call method "objectForInfoDictionaryKey:" of appBundle with parameter "CFBundleVersion"
	return appVersion
end stampsInstallerVersion

on chooseTuxPaintApplication()
	tell open panel
		set title to "Select the Tux Paint application:"
		set prompt to localized string "Choose"
		set treat packages as directories to false
		set can choose directories to false
		set can choose files to true
		set allows multiple selection to false
	end tell
	set title of window "winInstaller" to "Select the Tux Paint application:"
	display open panel in directory "/Applications" attached to window "winInstaller"
end chooseTuxPaintApplication

-- vim:noet:ft=sh
