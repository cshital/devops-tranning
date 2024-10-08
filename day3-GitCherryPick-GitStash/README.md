# Git Cherry Pick

## Scenario:
- You have two branches: `branch-A` and `branch-B`.
- You made a bug fix commit on `branch-A` that you now want to apply to `branch-B` without merging all changes from `branch-A` into `branch-B`.

### Steps:

#### Identify the Commit:
First, find the commit hash of the bug fix commit on `branch-A`:


```
git log --oneline branch-A
```
![](images/1.png)

Suppose the commit hash is abcdef1234567890.
Switch to branch-B:

Ensure you are on branch-B where you want to apply the bug fix:

```
git checkout branch-B
```
![](images/2.png)


If branch-B does not exist yet:

```
git checkout -b branch-B
```

Cherry-pick the Commit:
Apply the bug fix commit from branch-A to branch-B:

```
git cherry-pick abcdef1234567890
```
![](images/3.png)


- This command applies the changes introduced by the commit abcdef1234567890 onto branch-B.

- Resolve Conflicts (if any):

```
git cherry-pick --continue
```
![](images/4.png)

Commit the Cherry-picked Changes:
After resolving conflicts (if any), commit the cherry-picked changes on branch-B:

```
git commit
```
![](images/5.png)


If needed, you can also use:

```
git commit --allow-empty -m "Apply changes from commit abcdef1234567890"
```

![](images/6.png)


This creates a new commit on branch-B that includes the changes from branch-A's selected commit.

```
Git Stash
```

## Step 1: Initialize a Git Repository

First, create a new directory for your project and initialize a Git repository:

```
mkdir git-stash-example
```
![](images/7.png)

```
cd git-stash-example
```
![](images/8.png)

```
git init
```
![](images/39png)


## Step 2: Add and Commit Files

Create some files and add content to them:

```
echo "This is file1.txt" > file1.txt
```
```
echo "This is file2.txt" > file2.txt
```

![](images/10.png)

Add these files to the staging area and commit them:
git add file1.txt file2.txt

![](images/11.png)

```
git commit -m "Initial commit - Added file1.txt and file2.txt"
```
![](images/12.png)

## Step 3: Modify Files

Make some changes to file1.txt:

```
echo "Updated content in file1.txt" >> file1.txt
```
![](images/13.png)

## Step 4: Use git stash

Now, let's use git stash to temporarily store the changes in file1.txt without committing them:


git stash save "WIP: Work in progress changes"

![](images/14.png)


    This command saves your changes (in this case, the update to file1.txt) to a stash with a message "WIP: Work in progress changes".

## Step 5: Verify Stash

You can verify the stash list using:

```
git stash list
```
![](images/15.png)


- It should show something like:

- graphql stash@{0}: On master: WIP: Work in progress changes

## Step 6: Check Working Directory Status

Check the status of your working directory:

```
git status
```

- It should indicate that your working directory is clean (no changes).

![](images/16.png)

## Step 7: Apply Stashed Changes

Let's apply the stashed changes back into your working directory:

```
git stash pop
```
![](images/17.png)


## Step 8: Verify Changes

Check the changes in file1.txt:

```
cat file1.txt
```
![](images/18.png)


## Step 9: Commit Stashed Changes

If you are satisfied with the changes, commit them:

```
git add file1.txt
```
![](images/19.png)

```
git commit -m "Updated file1.txt with stashed changes"
```
![](images/20.png)

