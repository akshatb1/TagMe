
%---------------TEAM: PERCEPTION---------------------%

Instructions to run the code:

I. Folder arrangements:

a.Training Images must be separated into 5(Five) Folders based on their labels. The folders should
be named 1, 2, 3, 4 and 5 and kept in the C:/ drive. This address can be altered on line number 10 in the .m file.

1- Buildings
2- Cars
3- Flowers
4- Persons
5- Shoes

b. Test images should be located here: 'C:\TagMe!-TestData\Test\Images'; This address can be altered on line number 57 in the .m file

II. Tuning Parameters

a. Number of clusters, c : In order to change this, make changes on the following line numbers in the .m file.
c = 50, default.
Line:32
Line:38
Line:39
Line:73

b. Weights assigned to votes: In order to change this, make changes on the following line numbers in the .m file.

Line 126-130
III  Output Labels :
Output Labels are as following :
1. Building
2. Cars
3. Faces
4. Flowers
5. Shoes

%----------------------END---------------------------%


