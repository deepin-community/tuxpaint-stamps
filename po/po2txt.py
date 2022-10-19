#!/usr/bin/env python
# -*- coding: UTF-8 -*-

# po2txt.py for Tux Paint Stamps collection
#
# Last modified 2020-07-31
#
# Updates stamp description files ("stampname.txt"),
# which contain the textual description of the stamp
# in English, plus all languages it has been translated to.
# This script reads the various localization (".po") files
# to fill in the translated lines (e.g., "es=Description in Spanish").
# (Those ".po" files are based on a translation template ".pot" file,
# which is based on the main English strings found in the ".txt" files;
# the script "txt2pot.py" generates the ".pot" file.)

import sys, os, glob, string

def lister(dummy, dirname, filesindir):
   filesindir.sort()
   for fname in filesindir:
       fnlist = os.path.splitext(fname)
       # change the file ext name to .txt whan ready.
       if fnlist[1] == ".txt":
           print ">> " + dirname + "/" + fname
           # open txt file to read.
           txtFile = open(os.path.join(dirname, fname), 'rb')
           # get first line : the stamp description.
           searchText_unescaped = txtFile.readline()[:-1]
           searchText = string.replace(searchText_unescaped, '"', '\\"')
           fullsearchText = "msgid \"" + searchText + "\"\n"
	   # print "  " + searchText_unescaped
           if searchText in msgidsList:
               # reopen txt file to write.
               txtFile = open(os.path.join(dirname, fname), 'wb')
               # write back the description.
               txtFile.write(searchText_unescaped + '\n')
               # get locale code from the sorted localeList.
               for locale in localeList:
                   # seek position to the PO file's beginning.
                   localeFiles[locale].seek(0)
                   # search the searchText.
                   noFuzzy = 1
                   line = localeFiles[locale].readline()
                   while fullsearchText != line:
                       # determine fuzzy.
                       if line[:8] == '#, fuzzy':
                           noFuzzy = 0
                       else:
                           if line[:6] == 'msgstr':
                               noFuzzy = 1
                       line = localeFiles[locale].readline()
                   # if matched, read the next line, will be translated description.
                   line = localeFiles[locale].readline()
                   if line[:6] == 'msgstr' and line[8:-2] != "" and noFuzzy:
		       translation_unescaped = string.replace(line[8:-2], '\\"', '"')
                       txtFile.write("%s.utf8=%s\n" % (locale, translation_unescaped))
           txtFile.close()

def parsePOT(potFileName):
   try:
       potFile = open(potFileName, 'rb')
   except IOError, e:
       print "Unable to open the file:" , potFileName, e
   print potFileName
   # pass the pot header
   while len(potFile.readline()) > 1 : pass
   # parse filename and msgid
   for line in potFile.readlines():
       if line[:5] == 'msgid':
           # get msgid.
           msgidsList.append(line[7:-2])
           # if msgid has more one line,
           # we need change the way.
   potFile.close()

if __name__ == '__main__':
   localeFiles = {}
   localeList = []
   msgidsList = []

   # parse pot file to fill msgidsList.
   parsePOT('./tuxpaint-stamps.pot')

   poFileNames = glob.glob('*.po')
   for poFileName in poFileNames:
       # add locale to localeList.
       localeList.append(poFileName[16:-3])
       # add po file to localeFiles.
       localeFiles[poFileName[16:-3]] = open(poFileName, 'rb')

   # sort locale code.
   localeList.sort()

   # walk around all .txt files.
   os.path.walk('../stamps/', lister, None)

   # close all po files.
   for locale in localeList:
       localeFiles[locale].close()
