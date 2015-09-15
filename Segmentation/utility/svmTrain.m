function svm = svmTrain(X,Y,kertype)

options = optimset;    
options.LargeScale = 'off';
options.Display = 'off';

n = length(Y);
H = (Y'*Y).*kernel(X,X,kertype);
f = -ones(n,1); 
A = -eye(n);
b = zeros(n,1);
Aeq = Y; 
beq = 0;
lb = []; 
ub = [];
a0 = zeros(n,1);  
a  = quadprog(H,f,A,b,Aeq,beq,lb,ub,a0,options);

epsilon = 1e-8;                     
sv_label = find(abs(a)>epsilon);    
svm.a = a(sv_label);
svm.Xsv = X(:,sv_label);
svm.Ysv = Y(sv_label);
svm.svnum = length(sv_label);
