clc
close all
clear all

originimage = imread('smita.jpg');

a = originimage;

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

    
    figure
    imshow(uint8(a)),title('Original Image');
    figure
    imshow(uint8(new_image)),title('Gradient Homo filter Image');
    
%     imwrite(uint8(new_image),'reci_gradu_weighted_0.5.bmp','bmp')
diff1=imabsdiff(a,new_image);

figure,
imshow(uint8(256*diff1))