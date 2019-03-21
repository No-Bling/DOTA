
### No-Bling DOTA mod builder now uses just the following in-house external tool:  

# VPKMOD  
VPK reading based on [ValveResourceFormat's c# Decompiler cli](https://opensource.steamdb.info/ValveResourceFormat/)  
VPK writing losely adapted from [ValvePython's python vpk module](https://pypi.python.org/pypi/vpk)  
VPK filtering and in-memory unpak-rename-pak modding by AveYo  
_Binary should be compatible with built-in .net 2.0 in Windows 7 with the help of the bundled LinqBridge library_  
_C# Source code provided as a self-compiling .bat file via csc in .net 3.5+ or msbuild project in VS2008+_  

### Optional:  
`No-Bling DOTA mod builder.js` can be processed up to 30s faster by using Node.js instead of default JScript engine  
_As of 7.14 r1, no longer bundled, but you can drop node.exe in tools/ and it will get picked up automatically_  

