# About H08 v24 development
This GitHub repository is mainly used for those who want to join and contribute to the development of H08. 

If you simply would like to use H08, please download the latest release file (tar .gz or zip) from the "Releases" menu in the right area of this repository page.  

The H08 manual and the sample data for execution can be downloaded from [the H08 web page](https://h08.nies.go.jp/h08/manual.html). 

The code of H08 is distributed under the Apache 2.0 license. The code can therefore be freely used or modified.

(Note: Regarding the global meteorological data distributed from [A-PLAT Pro](https://ccca-scenario.nies.go.jp/), please follow the license of the data distributor.) 

We are currently discussing the procedure for cooperation from external contributors for the further development of H08.

A preliminary proposal on how to merge contributions from multiple external contributors is as follows ;

## Naming convention for branch
- main: Main repository (the latest stable code) 
- release_v24. XX: Code archive released as v24. XX (not modifiable) 
- develop24XX:  The root of the v24.XX-based development branch (fork and contribute from here) 
- dev24XX_PROJ: A working branch for merging development projects into the development branch (Please contact us if you want to create pull requests. We will create a dedicated working branch for you with this name to merge changes). 

## Procedure for requesting updates such as adding new schemes
1. If you have a new scheme to integrate into the main of H08, please contact the repository owner. 
2. Please accept the invitation to join the development team and fork the development branch: develop24XX.
3. Follow the rules below to make some modifications ;
   - Please allow the added scheme to be turned on/off with a switch. It's even better if turning off the new scheme doesn't affect the original code.
   - If a new scheme by multiple contributors causes conflicts, please consult with the repository owner.
   - It would be appreciated if you could prepare a sample script to run the H08 under the new scheme. If possible, please design the script so that others can run it. For example, avoid absolute paths, avoid environment-dependent shebang (e.g., #!/usr/local/python), and describe the libraries required.
   - If additional data is required to run the new scheme, please provide sample data (should be of minimal size). Please make sure to keep the data outside of GitHub. If the new scheme requires data, please contact the repository owner to discuss how to manage the data in H08.
4. When you're ready to merge your code, please contact the repository owner. Then, we'll create a working branch dev24XX_PROJ for merging your commits.
   - Please fork dev24XX_PROJ and _reflect your changes on this branch_[^1] (only for necessary changes).
   - Since it is developed by several people, dev24XX_PROJ may have changed from the development branch you originally forked (develop24XX). If you find conflicts that you cannot resolve, please consult the repository owner.
5. Please make a pull request to dev24XX_PROJ branch.
   - If your commit cannot be merged into dev24XX_PROJ due to conflicts, we will contact you. 
6. Your new contributions will be merged into dev24XX_PROJ at first.
   - The repository owner will run a test simulation to confirm that your modification (contribution) works well.
   - Then, dev24XX_PROJ branch is merged into the develop24XX branch.
   - To Merge this new scheme into main branch will be considered later.

[^1]: (1). On the H08 repository page, select the dev24XX_PROJ branch using the switch selection button under the repository name to display the dev24XX_PROJ branch.<br>(2). Click the "Fork" button in the upper right corner to fork the dev24XX_PROJ branch to your GitHub page.
<br>(3). "Git pull" the forked dev24XX_PROJ branch to your local repository. At this time, there may be conflicts between locally modified files and files in the pulled branch, so modify the local files to resolve the conflicts before successfully pulling the dev24XX_PROJ branch.<br>(4). Checkout to the dev24XX_PROJ branch that you pulled locally, and then register the modified and added files ("git add" and "git commit"). This registration of changes to the local repository in the dev24XX_PROJ branch is called **reflection**.
