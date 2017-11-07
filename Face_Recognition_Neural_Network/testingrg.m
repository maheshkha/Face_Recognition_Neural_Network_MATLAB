close all
clear all
clc
gmean = 0.2973
rmean = 0.4270
grcov = [0.0016    0.0002
         0.0002    0.0063];
inverserg = [620.4978  -20.9607
             -20.9607  159.0397];


im = imread('test08.jpg');
figure,imshow(im);
imycbcr = rgb2ycbcr(im);
dim = size(im);
skin1 = zeros(dim(1), dim(2));

for i = 1:dim(1)
for j = 1:dim(2)
r = double(im(i,j,1))/sum(double(im(i,j,:)));
g = double(im(i,j,2))/sum(double(im(i,j,:)));
x = [(r-rmean); (g-gmean)];
skin1(i,j) = exp(-0.5*x'*inverserg*x);
end
end
figure;imshow(skin1, [0 1]);title('skin1');


skin2=zeros(i,j);
for i=1:dim(1)
    for j=1:dim(2)
        if (skin1(i,j)>0.7)
            skin2(i,j)=1;
        else
            skin2(i,j)=0;
        end
    end
end
%figure,imshow(skin2,[0 1]);
%title('AFTER SKIN COLOR SEGMENTATION')
B=skin2;
C = bwfill(B,'holes');
edge_img = edge(B,'canny');
edge_img = ~edge_img;
C = 255*(double(C) & double(edge_img));
C = bwfill(C,'hole');
%figure,imshow(C);

%dilation and erosion operations
SE = ones(7);
E = imdilate(C,SE);
%figure,imshow(E);
SE1 = ones(5);
F = imerode(E,SE1);
 %figure,imshow(F);
[segments, num_segments] = bwlabel(F);
boxInfo = [];
for i = 1:num_segments,
[row col] = find(segments == i);
[ctr, hWdth] = boxInfofunction(row, col);
boxInfo = [boxInfo; ctr hWdth];
end
imshow(uint8(im))
hold on
S=max(boxInfo(:,3,:));
S1=floor(S/2);
for i = 1:num_segments,
    if (boxInfo(i,3,1)>S1)
        a=boxInfo(i,:,:);
        hd=rectangle('position',[a(2)-round(2*S/2.5),a(1)-round(2*S/2.5),ceil(3*S/2.5),ceil(3*S/2.0)]);
        set(hd, 'edgecolor', 'y');
    end
end

