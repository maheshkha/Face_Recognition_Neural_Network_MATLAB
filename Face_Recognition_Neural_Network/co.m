

x=[1 1 1 ];
h=[1 2 3 ];
n=length(x);
m=length(h);
y=zeros(1,m+n-1)
  for i=1:n
      for j=1:m
          y(i+j-1)= y(i+j-1) + x(i).*h(j)
      end
  end    
  