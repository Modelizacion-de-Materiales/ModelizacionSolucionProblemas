function [MC,A,E]=gethisel(str,nxe);

thisdata=strread(str);

MC(1:nxe)=thisdata(2:nxe+1);
A=thisdata(1+nxe+1);
E=thisdata(1+nxe+2);