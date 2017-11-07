%Simple demonstration of one image face detection operation.

clear
close all

x=imread('sanu.jpg');
imshow(x),title('Orignal Image');
if (size(x,3)>1)%if RGB image make gray scale
    try
        x=rgb2gray(x);%image toolbox dependent
    catch
        x=sum(double(x),3)/3;%if no image toolbox do simple sum
    end
end
x=double(x);%make sure the input is double format
[output,count,m,svec]=facefind(x);%full scan 


figure,imagesc(x), colormap(gray)%show image
plotbox(output,[],8)%plot the detections as red squares
plotsize(x,m)%plot minmum and maximum face size to detect as green squares in top left corner
title('Face find Image');

   N=size(output,2);

if (N>0)
    x1=output(1,1);
    x2=output(3,1);
    y1=output(2,1);
    y2=output(4,1);
    img=imcrop(x,[x1 x2 y1 y2]);
    % Load the face images, normalize, and set training vectors
     % IM = imread('./scaled/test05-c.jpg');
    IM = imresize(img,[27 18]);
     imwrite(uint8(IM),'sanu_face.jpg'); 
end
