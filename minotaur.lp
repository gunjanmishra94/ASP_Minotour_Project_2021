% Please insert the names and email addresses of the group members:
% Sreyas Sony, sony@uni-potsdam.de
% Gunjan Mishra, mishra@uni-potsdam.de
% Divya Bhadauria, divya.bhadauria@uni-potsdam.de

differ(0,1). differ(0,-1). differ(1,0). differ(-1,0).
diff(1,0,0). diff(-1,0,0). diff(0,1,0). diff(0,-1,0).  diff(0,0,0). diff(0,0,1).
mdiff(2,0). mdiff(1,0). mdiff(1,1). mdiff(1,-1). mdiff(0,2). mdiff(0,1).
mdiff(-1,1). mdiff(-1,0). mdiff(-2,0). mdiff(-1,-1). mdiff(0,-1). mdiff(0,-2).

move(X,Y,0) :- start(X,Y).
at(X,Y,0):-start(X,Y).
    
%Determine all the possible paths for the movement
move(X1,Y1,X2,Y2):field(X2,Y2),field(X1,Y1),differ(X1-X2,Y1-Y2).
:-move(X1,Y1,X2,Y2),wall(X1,Y1,X2,Y2).
:-move(X1,Y1,X2,Y2),wall(X2,Y2,X1,Y1).
1{move(X1,Y1,X2,Y2):field(X2,Y2),differ(X1-X2,Y1-Y2)}1:-move(_,_,X1,Y1),not goal(X1,Y1).

minotaur(X,Y,0) :- mino(X,Y).

{move(X+X1,Y+Y1,T):diff(X1,Y1,(T-1)\2),field(X+X1,Y+Y1),not minotaur(X+X1,Y+Y1,T-1),
 not wall(X+X1,Y+Y1,X,Y),not wall(X,Y,X+X1,Y+Y1)}=1 :- move(X,Y,T-1),not destination(X,Y,T-1),T<=2*M,maxsteps(M).

%There should be no path from the goal cell.
:-move(X1,Y1,_,_),goal(X1,Y1).
    
%Determine the total possible paths
%total(2*2*N*(N-1)):-N= #count{X: field(X,Y)}.
%walls(2*N):-N= #count{1,A,B,C,D: wall(A,B,C,D)}.
%total_paths(A-B):-maxsteps(A),walls(B).

minotaur(X+1,Y,T) :- minotaur(X,Y,T-1), move(A,B,T), X-A < 0, field(X+1,Y), minotaur(X,Y,T-1), not wall(X,Y,X+1,Y), not wall(X+1,Y,X,Y).
minotaur(X-1,Y,T) :- minotaur(X,Y,T-1), move(A,B,T), X-A > 0, field(X-1,Y), minotaur(X,Y,T-1), not wall(X,Y,X-1,Y), not wall(X-1,Y,X,Y).
minotaur(X,Y+1,T) :- minotaur(X,Y,T-1), move(A,B,T), Y-B < 0, field(X,Y+1), minotaur(X,Y,T-1), not minotaur(X+1,Y,T), not minotaur(X-1,Y,T), not wall(X,Y,X,Y+1), not wall(X,Y+1,X,Y).
minotaur(X,Y-1,T) :- minotaur(X,Y,T-1), move(A,B,T), Y-B > 0, field(X,Y-1), minotaur(X,Y,T-1), not minotaur(X+1,Y,T), not minotaur(X-1,Y,T), not wall(X,Y,X,Y-1), not wall(X,Y-1,X,Y).
minotaur(X,Y,T)   :- minotaur(X,Y,T-1), move(A,B,T), minotaur(X,Y,T-1), not minotaur(X+1,Y,T), not minotaur(X-1,Y,T),not minotaur(X,Y+1,T), not minotaur(X,Y-1,T).

%Determine all the possible paths for minotaur
minotaur(X1,Y1,X2,Y2):field(X2,Y2),field(X1,Y1),mdiff(X1-X2,Y1-Y2).
:-minotaur(X1,Y1,X2,Y2),wall(X1,Y1,X2,Y2).
:-minotaur(X1,Y1,X2,Y2),wall(X2,Y2,X1,Y1).
:-minotaur(X1,Y1,X2,Y2),wall(X1-1,Y1,X2,Y2).
:-minotaur(X1,Y1,X2,Y2),wall(X2,Y2,X1-1,Y1).
:-minotaur(X1,Y1,X2,Y2),wall(X1+1,Y1,X2,Y2).
:-minotaur(X1,Y1,X2,Y2),wall(X2,Y2,X1+1,Y1).
:-minotaur(X1,Y1,X2,Y2),wall(X1,Y1-1,X2,Y2).
:-minotaur(X1,Y1,X2,Y2),wall(X2,Y2,X1,Y1-1).
:-minotaur(X1,Y1,X2,Y2),wall(X1,Y1+1,X2,Y2).
:-minotaur(X1,Y1,X2,Y2),wall(X2,Y2,X1,Y1+1).
:-minotaur(X1,Y1,X2,Y2),wall(X2,Y1,X1,Y1),wall(X1,Y2,X1,Y1).
:-minotaur(X1,Y1,X2,Y2),wall(X1,Y1,X2,Y1),wall(X1,Y1,X1,Y2).

    
:-move(X,Y,T), minotaur(X,Y,T).
:-move(_,_,T),not minotaur(_,_,T).
:-move(X,Y,T),diff(X1,Y1,_),not wall(X,Y,X+X1,Y+Y1), not wall(X+X1,Y+Y1,X,Y),minotaur(X+X1,Y+Y1,T-1).

destination(X,Y,T) :- goal(X,Y), move(X,Y,T),not minotaur(X,Y,T),T\2=0.
:-goal(X,Y),not destination(X,Y,_).

#minimize{X :destination(_,_,X)}.
at(X,Y,T):-move(X,Y,Z),2*T=Z.

#show at/3.
