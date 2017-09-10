% In order to run the code please refer to the README file provided.
% Written by Akshat Bordia and Pranav Sodhani

clc;
clear all
count =0;
descr  = cell(1,500); 
desc_mat=zeros(1,64);

for class = 1:5
    folder= sprintf('C:/%d', class);
    cd(folder);
    myfiles = dir('*.jpg');
    n = length(myfiles); % n = 100 in our case as each class contains 100 training samples.
    numofrows = 0;
    for j = 1:n
        filename = myfiles(j).name;
        Image = (rgb2gray(imread(filename)));        
        s = detectSURFFeatures(Image);
        [features,validPoints] = extractFeatures(Image,s);  
        descr{j+count} = features;
        [M, N] = size(features);
        numofrows = numofrows + M;
        desc_mat = [desc_mat;descr{j+count}];  % desc_mat: Matrix which contains all the SURF Features
    end
    num(class) = numofrows;
    count = count +100
end

[s1,s2] = size(desc_mat);
final =[desc_mat(2:s1,:)];      % Removing the initial zero row of desc_mat.

[IDX, C] = kmeans(final, 50);   % Clustering the SURF points into c (c = 50) clusters. 
                                % C contains centroids of each of the 50 clusters.


%---- Allotting a different Matrix, D{i} to each of the 50 clusters which contain feature vectors-----%

D =cell(1,50);
for i=1:50 % for c (c = 50) clusters
    count=1;
    for j =1:numel(IDX)           
        if IDX(j) == i       
            D{i}(count,:) = final(j,:);
            ad{i}(count)= j;
            count =count+1;
        end
    end
end

% --------------------------------END of training module-----------------------------%

% Testing on Data : This consists of extracting the SURF features of a  test image and 
% classifying them into the previously computed clusters made (from training data) and 
% then for each SURF point of test image, we find its nearest neighbour in its corresponding
% cluster. And then, we retrieve the class of this Nearest Neighbour from 'ad' matrix 
% and a voting is done based on its class. The image is assigned to the class for which
% it has maximum no. of votes.

folder ='C:\TagMe!-TestData\Test\Images';
cd(folder);
myfiles = dir('*.jpg');

for k = 1:numel(myfiles)
    filename = myfiles(k).name;
    Image = (rgb2gray(imread(filename)));
    s = detectSURFFeatures(Image);
    [features,validPoints] = extractFeatures(Image,s);
    [M, N] = size(features);
    
    % Finding the nearest neighbour in the cluster into which feature vector falls.
    
    for j=1:M
        for i =1:50 % for c ( c = 50) clusters
            a(i) = norm(features(j,:) - C(i,:));
        end
        [dist,ind] = min(a);
        index1(j) = ind;
    end
       
    [M, N] = size(features);
    % v1, v2, v3, v4, v5 are vote-count of different classes.
    v1 =0;
    v2 =0;
    v3 =0;
    v4 =0;
    v5 =0;
    for t=1:M
        clear U
        clear mydistance
        clear X
        X = D{index1(t)};
        [sr1, sc] = size(X);
        for p =1:sr1
            w=(1000*X(p,:) - 1000*features(t,:));
            mydistance(p) =w*w';
        end
        [val,d] = min(mydistance);
        clear val
        
        U = ad{index1(t)}; 
        
        % ---------------------Voting for each class---------------------------
        
        if U(1,d)<=num(1)
            v1 =v1+1;
        end
        
        if U(1,d)>num(1) & U(1,d)<=sum(num(1:2))
            v2 =v2+1;
        end
        
        if U(1,d)>sum(num(1:2)) & U(1,d)<=sum(num(1:3))
            v3 =v3+1;
        end
        
        if U(1,d)>sum(num(1:3)) & U(1,d)<=sum(num(1:4))
            v4 =v4+1;
        end
        
        if U(1,d)>sum(num(1:4)) & U(1,d)<=sum(num(1:5))
            v5 =v5+1;
        end
    end
    %--------------- Assigning weights to votes of each class------------------
    
    v1 = v1*(60/13);
    v2 = v2*(60/18);
    v3 = v3*(60/16);
    v4 = v4*(60/8);
    v5 = v5*(60/6);
    
    %------------------Classification into different classes--------------------
    
    if v1>v2 & v1>v3 & v1>v4 & v1>v5
        strcat(filename ,' 1')
    end
    if v2>v1 & v2>v3 & v2>v4 & v2>v5
        strcat(filename ,' 2')
    end
    % Since the class order defined in the problem was different than what we had 
    % used, we had to alter this to enure correct class number.
    
    if v3>v1 & v3>v2& v3>v4 & v3>v5
        strcat(filename ,' 4') 
    end
    % Since the class order defined in the problem was different than what we had 
    % used, we had to alter this to enure correct class number.
    
    if v4>v2 & v4>v1 & v4>v5 & v4>v3
        strcat(filename ,' 3')
    end
    if v5>v2 & v5>v3 & v5>v4 & v5>v1
        strcat(filename ,' 5')
    end
end  

%--------------------------------- END ------------------------------------------