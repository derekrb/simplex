function [A, b, c, z] = canon(A, b, c, basis, z)

% canon converts any SEF LP into canonical form
% (c) Derek Bennewies
% Last edited Feb 1, 2013
%
% A is the m x n constraint matrix of the LP
% b is the m x 1 constraint values of the LP
% c is the n x 1 objective coefficients
% basis is a vector containing the column indicies of a basis of A


% Useful Variables
m = rows(A);


% Initialize basis matrices/vectors
Ab = zeros(m, m);
cb = zeros(m, 1);

% Place values into basis matrices/vectors
for i = 1:m
    Ab(:, i) = A(:, basis(i));
    cb(i) = c(basis(i));
end

% Calculate y
y = inv(Ab') * cb;


%% Calculate canonical form
z = z + y' * b;
c = (c' - y' * A)';
A = inv(Ab) * A;
b = inv(Ab) * b;