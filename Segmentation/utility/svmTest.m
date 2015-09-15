function result = svmTest(svm, Xt, kertype)
temp = (svm.a'.*svm.Ysv)*kernel(svm.Xsv,svm.Xsv,kertype);
total_b = svm.Ysv-temp;
b = mean(total_b);
wx = (svm.a'.*svm.Ysv)*kernel(svm.Xsv,Xt,kertype);
result.score = wx + b;
Y = sign(wx+b);
result.Y = Y;
