# AVD Application Group - Base test case

This is an example for setting-up a an Azure Virtual Application Group and associate it with an AVD Workspace

This test case:
- Sets the different Azure Region representation (location, location_short, location_cli ...) --> module "regions"
- Instanciates a map object with the common Tags ot be applied to all resources --> module "base_tagging"
- Creates the following resource dependencies
    - Resource Group
    - Log Analytics workspace
    - AVD Host Pools  (Desktop, Rail)
    - AVD Workspace
- Creates two  AVD Application Groups (Desktop, Rail) --> module "avdworkspace" which also
    - Set the default diagnostics settings (All Logs and metric) whith a Log Analytics workspace as destination
    - Associate with an AVD Workspace

<!-- BEGIN_AUTOMATED_TF_DOCS_BLOCK -->

<!-- END_AUTOMATED_TF_DOCS_BLOCK -->
