function highlighted= dethighlightBold(im,blocksize,detections)
%%%%% 
% detections:predictlabel:0 or 1
% The purpose of this function is to highlight blocks which have been
% identified as tampered.
% written by Matthew C Stamm 4/09
%%%%%%%%%%%%%%%%%%%%%%
rval = 255;bval = 0;gval = 0;
[rows cols colors]= size(im);
rowblocks = floor(rows/blocksize);   
% caculate the number of blocks contained in the colnum
colblocks = floor(cols/blocksize);     
% caculate the number of blocks contained in the rownum %cols/blocksize;
if colors == 1
    newim(:,:,1)= im;
    newim(:,:,2)= im;
    newim(:,:,3)= im;
    im = newim;
end
% pick red color layer for highlighting
highlighted= im;

for rowblock= 1:rowblocks
    for colblock= 1:colblocks        
        if detections(rowblock,colblock) == 1       
    % Kmeans 结果里篡改部分（小的一簇）标签为2
            rowst= (rowblock-1) * blocksize+ 1;
            rowfin= rowblock * blocksize;
            colst= (colblock-1) * blocksize + 1;
            colfin= colblock * blocksize; 
            % red
            highlighted(rowst:rowst+4,colst:colfin,1)= rval;
            highlighted(rowfin-4:rowfin,colst:colfin,1)= rval;
            highlighted(rowst:rowfin,colst:colst+4,1)= rval;
            highlighted(rowst:rowfin,colfin-4:colfin,1)= rval;         
            
            % green
            highlighted(rowst:rowst+4,colst:colfin,2)= gval;
            highlighted(rowfin-4:rowfin,colst:colfin,2)= gval;
            highlighted(rowst:rowfin,colst:colst+4,2)= gval;
            highlighted(rowst:rowfin,colfin-4:colfin,2)= gval;
            
            % blue
            highlighted(rowst:rowst+4,colst:colfin,3)= bval;
            highlighted(rowfin-4:rowfin,colst:colfin,3)= bval;
            highlighted(rowst:rowfin,colst:colst+4,3)= bval;
            highlighted(rowst:rowfin,colfin-4:colfin,3)= bval;         
            
            if rowst-1 > 0
                highlighted(rowst-5:rowst-1,colst:colfin,1)= rval;
                highlighted(rowst-5:rowst-1,colst:colfin,2)= gval;
                highlighted(rowst-5:rowst-1,colst:colfin,3)= bval;
               
                if colst-1 > 0
                    highlighted(rowst-5:rowst-1,colst-5:colst-1,1)= rval;
                    highlighted(rowst-5:rowst-1,colst-5:colst-1,2)= gval;
                    highlighted(rowst-5:rowst-1,colst-5:colst-1,3)= bval;  
                end
                if colfin+1 < cols
                    highlighted(rowst-5:rowst-1,colfin+1:colfin+5,1)= rval;
                    highlighted(rowst-5:rowst-1,colfin+1:colfin+5,2)= gval;
                    highlighted(rowst-5:rowst-1,colfin+1:colfin+5,3)= bval;
                end
            end
            
            if rowfin+1 < rows
                highlighted(rowfin+1:rowfin+5,colst:colfin,1)= rval;
                highlighted(rowfin+1:rowfin+5,colst:colfin,2)= gval;
                highlighted(rowfin+1:rowfin+5,colst:colfin,3)= bval;
                
                if colst-1 > 0
                    highlighted(rowfin+1:rowfin+5,colst-5:colst-1,1)= rval;
                    highlighted(rowfin+1:rowfin+5,colst-5:colst-1,2)= gval;
                    highlighted(rowfin+1:rowfin+5,colst-5:colst-1,3)= bval;
                end
                if colfin+1 < cols
                    highlighted(rowfin+1:rowfin+5,colfin+1:colfin+5,1)= rval;
                    highlighted(rowfin+1:rowfin+5,colfin+1:colfin+5,2)= gval;
                    highlighted(rowfin+1:rowfin+5,colfin+1:colfin+5,3)= bval;
                end
            end
            
            if colst-1 > 0
                highlighted(rowst:rowfin,colst-5:colst-1,1)= rval;
                highlighted(rowst:rowfin,colst-5:colst-1,2)= gval;
                highlighted(rowst:rowfin,colst-5:colst-1,3)= bval;
            end
            
            if colfin+1 < cols
                highlighted(rowst:rowfin,colfin+1:colfin+5,1)= rval;
                highlighted(rowst:rowfin,colfin+1:colfin+5,2)= gval;
                highlighted(rowst:rowfin,colfin+1:colfin+5,3)= bval;
            end            
        end        
    end
end
highlighted= uint8(highlighted);
% 
figure,imshow(highlighted,'Border','tight');