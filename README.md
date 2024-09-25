# Clean-UX
ShellScripts for cleaning linux in APT and DNF, emptying the disk of obsolete files.

Just download the `clean_ux.sh` file and execute it from the shell with `./clean_ux.sh`

## Actions
1. **Remove unnecessary packages**:  
      Automatically removes packages that were installed as dependencies and are no longer needed.

3. **Clean DNF cache**:  
      Deletes all files and metadata stored in the DNF package manager's cache.

4. **Remove old kernels** (preserving the penultimate version for recovery in case of failure):  
      Removes installed package versions that are not the most recent, keeping only the last two.

5. **Delete DNF cache**:  
      Clears all content in the specific DNF cache directory.

6. **Remove temporary files**:  
      Cleans the system's temporary directory by deleting unnecessary files.

7. **Delete log files**:  
       Removes all system log files, freeing up disk space.

8. **Empty the trash**:  
       Deletes all files stored in the current user's recycle bin.
