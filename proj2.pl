% Author: JiangxingYu <jiangxingy@student.unimelb.edu.au>
% Purpose: Math puzzles

% A maths puzzle is a square grid of squares, each to be 
% ﬁlled in with a single digit 1–9 (zero is not permitted
% and headings not considered to be part of row and column). 
% satisfying these constraints:
%  1. each row and each column contains no repeated digits;
%  2. all squares on the diagonal line from upper left to 
%     lower right contain the same value;
%  3. the heading of reach row and column (leftmost square in a 
%	  row and topmost square in a column) holds either the sum 
%      or the product of all the digits in that row or column.

:- ensure_loaded(library(clpfd)).

% This methods check whether the first number is 
% the sum of the follow numbers in the line.
make_sum(Row) :- 
	make_sum(Row, 0).
make_sum([Head], Sum) :-
	Head = Sum.
make_sum([Head, Ele|List], Sum):-
	Newsum is Sum + Ele, 
	make_sum([Head|List], Newsum).

% This methods check whether the first number is 
% the product of the follow numbers in the line.
make_product(Row) :- 
	make_product(Row, 1).
make_product([Head], Product) :-
	Head = Product.
make_product([Head, Ele|List], Product):-
	Newproduct is Product * Ele, 
	make_product([Head|List], Newproduct).

% This methods check whether the row contains no repeated elements.
no_repeat([_]).
no_repeat([_|List]) :-
	sort(List, Sortedlist),
	length(List, Len),
	length(Sortedlist, Sortedlen),
	Len = Sortedlen.

% This method pads the element of row with the number between 1 and 9.
padding_row([_]).
padding_row([_, Ele|List]) :-
	between(1, 9, Ele), 
	padding_row([_|List]).

% This method guarantee a row is suitable.
% The steps are as follows:
% 1. input numbers between 1 to 9 in a row.
% 2. check a row does not have repeated numbers
% 3. guarantee the first number of row are the product 
%    or sum of the rest numbers.
make_row_right(Row):-
	padding_row(Row), 
	no_repeat(Row),
	(make_sum(Row); make_product(Row)).

% This method guarantee rows in a matrix are reasonable
make_right([_]).
make_right([_, Row|Rows]) :-
	make_row_right(Row), 
	make_right([_|Rows]).

% This method guarantee the numbers on the diagonal are same
hypotenuse_equal(Matrix) :- 
	hypotenuse_equal(Matrix, _, 0).
hypotenuse_equal([_], _, _).
hypotenuse_equal([_, Row|Rows], Val, Nth) :-
	Mth is Nth + 1, 
	between(1, 9, Val), 
	nth0(Mth, Row, Val), 
	hypotenuse_equal([_|Rows], Val, Mth).

% This method solve the math puzzle
% The steps are as follows:
% 1. filling-in the same numbers in hypotenuse
% 2. filling-in numbers to makesure every row is suitable
% 3. transpose the matrix
% 4. guarantee every row in the matrix after transpose is also suitable
puzzle_solution(Matrix) :- 
	hypotenuse_equal(Matrix),
	make_right(Matrix),
	transpose(Matrix, MatrixT),
	make_right(MatrixT).
