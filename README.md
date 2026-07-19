# ExoBioSearch
Elite Dangerous: Calculates Payout Potentials for specific planet Type, Atmosphere, and Biologicals

I have generated a little app to help get an idea of what the payout might be for Exo sampling specific planets.  All of the raw data used to drive this application comes from a tweaked export of Marx’s data (https://forums.frontier.co.uk/threads/compendium-of-codex-requirements.538300/).  A big thanks is due in that direction!  (ExoBioSearch was developed/compiled using AutoIT).

ExoBioSearch will help you predict a specific payout range for bio sampling a planet based on its Planet Type (Discovery Scan), Atmosphere (Discovery Scan), and general plant species (DSS scan)

ExoBioSearch will help identify what the expected species (and their respective payouts) might be based on a planet type and atmosphere.  Additionally, once a DSS scan is done on the associated planet, it will provide list of general plant types you can use to further identify the specific plants you might be expected to encounter.  It will also list a potential payout range based on what you might encounter.

Assuming you are discovering new Star Systems (everyone likes first footfall, right?), the following would be the order of things required to acquire the associated data for determining plant species on a specific planet:

1.  FSS: Full Spectrum Scan the entire star system (If not already discovered).  (As you scan, note that a summary will pop up for each planet discovered including information as to whether any biologicals are present – we will revisit that information for all discovered planets at one time using the System Map).

2.  Enter the System Map, select POI’s (Points of Interest), select Landable Planets, and look for landables with a Blue Box (atmosphere).  Cycle through each landable with atmosphere (blue box) and check Planetary Info to see if it has any biologicals (fourth tab down on right).  If you have biologicals, note the planet type and atmosphere for each candidate.

3.  Run ExoBioSearch and select the corresponding Planet Type, and Atmosphere for each candidate. Leave the Species as “Any”.  You will see a list of possible Species types which MIGHT be encountered.

4.  DSS:  Fly out to the desired candidates and fully map them with the DSS (Detailed Surface Scanner). Once each candidate is fully mapped, you can cycle through the each of the associated biologicals (FSS default keybinds Q & E) to see their general types.  You now have a list of general types of biologicals which WILL be found on the candidate planet.

5.  In ExoBioSearch, check each of the General Species types which were indicated for each candidate. (In total for each planet:  Planet Type, Atmosphere, General Species from DSS scan).  You will now see a list of exactly what you MIGHT encounter and the associated payout range.  (Be sure to check “First Footfall” if appropriate).  Note that you can find exactly one – and only one – of each general species type.  You won’t be sure which specific type you will find until you actually start sampling the planet (unless only one of a general type is listed).

The interface for ExoBioSearch doesn’t require much explanation (I hope) with one exception.  The “Strict” checkbox relates to atmosphere searches which have multiple densities.  For Example:  If “Strict” is NOT checked, then a search for “Methane” will ALSO include plants found on “Methane-Rich” planets.  If “Strict” IS checked, then a search for “Methane” will NOT include plants found on “Methane-Rich” planets.

>-------------------------------------------

A current (as of this writing) export of Marx’s data is included in the ExoBioSearch archive.  However here are some notes on how to export/prepare your own data export in the future:

- A companion app is included (EBSCSVtoINI.exe) which will help create a new ExoBioSearch data file (ExoBioSearch.ini) from a tabbed delimited CSV file that has been exported from Marx’s spreadsheet.

- Before exporting any data, information needs to be normalized to provide discrete information (No “Not”, “Any”,  “All”, or “Bugged” references should exist in any key fields (Planets, Atmospheres).  NOTES are OK):

* Atmosphere references in the original spreadsheet should be updated to provide a specific list.  IOW: Anywhere “Not …” is referenced you should start with a full list of atmospheres and then just remove the associated atmospheres.  ExoBioSearch wants a complete list of all possible atmospheres for each plant type.  “All” or “Not…” will require adjustments.

* Similarly “All” for Planet Types will need to be replaced with a specific list like “HMC, Icy, Rocky, Rocky Ice“

* Any data marked “(Bugged)”, other than in NOTES, should also be removed or adjusted as desired.

- Export the updated spreadsheet to a TAB delimited CSV file.  (We need to use tabs because some fields will contain commas).

- Run EBSCSVtoINI.exe to process the exported CSV and create the baseline INI file for ExoBioSearch.  The output INI file will named “ExoBioSearch.ini”.

- Place “ExoBioSearch.ini” in the same folder as “ExoBioSearch.exe”.

