function Component() {}
Component.prototype.createOperations = function()
{
    component.createOperations();
    component.addOperation("CreateShortcut", 
                           "@TargetDir@/NVR Cryptowallet/NVR Cryptowallet.exe", 
                           "@StartMenuDir@/NVR Cryptowallet.lnk", 
                           "workingDirectory=@TargetDir@");
    component.addOperation("CreateShortcut", 
                           "@TargetDir@/NVR Cryptowallet/NVR Cryptowallet.exe", 
                           "@DesktopDir@/NVR Cryptowallet.lnk");
}
