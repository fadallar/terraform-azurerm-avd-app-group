# AVD Workspace - Base test case

This is an example for setting-up a an Azure Virtual Desktop Workspace with private endpoint configuration  

This test case:
- Sets the different Azure Region representation (location, location_short, location_cli ...) --> module "regions"
- Instanciates a map object with the common Tags ot be applied to all resources --> module "base_tagging"
- Creates the following module dependencies
    - Resource Group
    - Log Analytics workspace
- Creates an Azure Virtual Desktop Workspace --> module "avdworkspace" which also
    - Set the default diagnostics settings (All Logs and metric) whith a Log Analytics workspace as destination

<!-- BEGIN_AUTOMATED_TF_DOCS_BLOCK -->

<!-- END_AUTOMATED_TF_DOCS_BLOCK -->
