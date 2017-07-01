function i=calnoise(i,ent)
        if(entropy(i)>ent)
           i(:)=1;         
        else
          i(:)=0;
         end;
end

