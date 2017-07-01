function img=loadimage
imagefolder='H:\STUDY MATERIAL\5sem\IMAGE VISION\image_project\matlab\image\';
fileextension='.bmp';
img=cell(1,1);
fprintf('Loading images');
foldercontent=dir([imagefolder,'*',fileextension]);
n=size(foldercontent,1);
for i=15:30
    fprintf ('.');  
    string = [imagefolder,foldercontent(i,1).name];
    image = imread(string);
   
    img{i,1}=string;
    img{i,2}=image;
    img{i,3}=medfilt2(img{i,2});
    img{i,4}=entropy(img{i,3});
    ent=img{i,4};
    fun=@(block_struct) calnoise(block_struct.data,ent);
    img{i,5}=blockproc(img{i,3},[15 15],fun);
    img{i,6}= bwconncomp(img{i,5},8);               % 8-connected component
    img{i,7}=labelmatrix(img{i,6});
    BW=img{i,7};
    img{i,8}=label2rgb(img{i,7},@spring,'c','shuffle');
    figure,imshow(img{i,5},[]);
    figure,imshow(img{i,8},[]);
    
   
    
    fid=fopen('groundTruth1.txt');
    img{i,9}=fscanf(fid,'%d');
    T=img{i,9};
    img{i,10}=img{i,6}.NumObjects;
    img{i,11}=bwconncomp(img{i,5},4);        % 4-connected component
    img{i,12}=img{i,11}.NumObjects;
    img{i,13}=(img{i,10}/T(i))*100;           % Detection rate 8-connected component    
    img{i,14}=(img{i,12}/T(i))*100;           % Detection rate 4-connected component
    
    %false alarm rate
    k=((img{i,12}-T(i))/T(i))*100; 
    if k > 0
    img{i,15} = k;
    else
      img{i,15} = 0;  
    end
    
    figure,imshow(img{i,2});
    hold on
     for j=1:img{i,10}
     [y, x, v]=find(BW==j);
     xval=min(x);
     xval1=max(x);
     yval=min(y);
     yval1=max(y);
     wd=yval1-yval;
     ht=xval1-xval;
     rect=[xval,yval, wd, ht];
%      figure,imshow(img{i,2});
%      hold on
xdata=[xval, xval+ht];
ydata=[yval, yval];
line('XData',xdata,'YData',ydata,'color','r','LineWidth',1);
xdata=[xval, xval];
ydata=[yval, yval+ht];
line('XData',xdata,'YData',ydata,'color','r','LineWidth',1);

xdata=[xval, xval+wd];
ydata=[yval+ht, yval+ht];
line('XData',xdata,'YData',ydata,'color','r','LineWidth',1);

xdata=[xval+wd, xval+wd];
ydata=[yval+ht, yval];
line('XData',xdata,'YData',ydata,'color','r','LineWidth',1);
     end

end

