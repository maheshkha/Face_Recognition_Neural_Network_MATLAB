close all
clear all
warning off
clc


im = imread('smita1.jpg');
figure,imshow(im),title('Input image')

rgb_i=rgb2gray(im);
figure,imshow(rgb_i),title('gray image')

figure,imhist(rgb_i)
rgb_i_eq = histeq(rgb_i);
figure,imshow(rgb_i_eq),title('eq hist image')


imycbcr = rgb2ycbcr(im);
dim = size(im);
skin1 = zeros(dim(1), dim(2));

bmean =  0.2862;
rmean =  0.3742;
% bmean =  mean(mean(imycbcr(:,:,2)))/(dim(1));
% rmean =  mean(mean(imycbcr(:,:,3)))/(dim(1));

inverse = [ 609.4718 -342.6169
            -342.6169  518.0453];

for i = 1:dim(1)
for j = 1:dim(2)
cb = double(imycbcr(i,j,2))/sum(double(imycbcr(i,j,:)));
cr = double(imycbcr(i,j,3))/sum(double(imycbcr(i,j,:)));
x = [(cb-bmean); (cr-rmean)];
skin1(i,j) = exp(-0.5*x'*inverse*x);
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
figure,imshow(skin2,[0 1]);
title('AFTER SKIN COLOR SEGMENTATION')
B=skin2;
C = bwfill(B,'holes');

% edge_img = edge(B,'canny');
a=B;
a = double(a);
[dep,wide] = size(a);
new_image = ones(size(a));

% control parameters for filter steps r = 0-1
r=0.9;
for i=2:dep-1
    for j=2:wide-1
        g=0;
          for m=-1:1
              for n=-1:1
                  if(a(i+m,j+n)-a(i,j)==0)
                      g(m+2,n+2)=0;
                  else
                      g(m+2,n+2)=1/abs(a(i+m,j+n)-a(i,j));
                  end
              end
          end
          
          G=sum(sum(g));
          for m=-1:1
              for n=-1:1
                  w(m+2,n+2)=g(m+2,n+2)/G;
              end
          end
          % homophirc filter mask applied here
          new_image(i,j)=a(i,j)*r+(w(-1+2,-1+2)*a(i-1,j-1)+w(-1+2,0+2)*a(i-1,j)+w(-1+2,1+2)*a(i-1,j+1)+w(0+2,-1+2)*a(i,j-1)+w(0+2,1+2)*a(i,j+1)+w(1+2,-1+2)*a(i+1,j-1)+w(1+2,0+2)*a(i+1,j)+w(1+2,1+2)*a(i+1,j+1))*(1-r);
    end
end

% homophric filter done

for i=2:dep-1
    new_image(i,1)=new_image(i,2);
    new_image(i,wide)=new_image(i,wide-1);
end

new_image(1,:)=new_image(2,:);
new_image(dep,:)=new_image(dep-1,:);
edge_img = im2bw(new_image);

figure,imshow(edge_img,[0 1]);
title('homophric edge detected segments')

edge_img = ~edge_img;
C = 255*(double(C) & double(edge_img));
C = bwfill(C,'hole');

%dilation and erosion operations
SE = ones(7);
E = imdilate(C,SE);
%figure,imshow(E);
SE1 = ones(5);
F = imerode(E,SE1);
% figure,imshow(F);
[segments, num_segments] = bwlabel(F);
boxInfo = [];
for i = 1:num_segments,
[row col] = find(segments == i);
[ctr, hWdth] = boxInfofunction(row, col);
boxInfo = [boxInfo; ctr hWdth];
end
% figure,
% imshow(uint8(im))
% hold on
% S=max(boxInfo(:,3,:));
% S1=floor(S/2);
% for i = 1:num_segments,
%     if (boxInfo(i,3,1)>S1)
%         a=boxInfo(i,:,:);
%         hd=rectangle('position',[a(2)-round(2*S/2.5),a(1)-round(2*S/2.5),ceil(3*S/2.5),ceil(3*S/2.0)]);
%         set(hd, 'edgecolor', 'r');
%     end
% end
rgb_i=double(rgb_i);
[output,count,m,svec]=facefind(rgb_i);%full scan 

figure,imagesc(rgb_i), colormap(gray)%show image
plotbox(output,[],8)%plot the detections as red squares
title('Face find Image');

              