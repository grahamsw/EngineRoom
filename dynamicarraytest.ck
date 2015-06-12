int b[0][0];

int a[0];
<<< "poop">>>;
a << 2;

a << 3;
a << 4;

b << a;

int  c[0];

c << 7;
c << 9;

b << c;
for ( 0 => int j; j < b.cap(); j++){
for(0 => int i; i < b[j].cap(); i++){
   <<< j, i, b[j][i] >>>; 
}
}


<<< "cap", a.cap() >>>;
<<< "size", a.size() >>>;