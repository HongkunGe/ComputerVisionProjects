function bnd_refer = to_refer(bnd, image)
v1 = bnd(2,:);
v2 = bnd(1,:);
bnd_refer = [image.R_t' , image.t ] * [ v1(1) v1(1) v1(1) v1(1) v2(1) v2(1) v2(1) v2(1);
                                        v1(2) v1(2) v2(2) v2(2) v1(2) v1(2) v2(2) v2(2);
                                        v1(3) v2(3) v1(3) v2(3) v1(3) v2(3) v1(3) v2(3); ones(1,8)];
end