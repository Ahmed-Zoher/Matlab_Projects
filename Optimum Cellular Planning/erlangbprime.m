function eprime = erlangbprime(N, A)
% eprime = ERLANGBPRIME(N, A) 1st derivative of Erlang-B blocking probability with respect to
% a (traffic intensity in Erlangs)
% Mainly a helper function for Newton-Raphson method used in INVERLANG

% This code is freeware as defined by Free Software Foundation "copyleft" agreement. (C)2000 Colin Warwick

% Comments, bugs, MRs to cwarwick@home.com. Offered "as is". No warranty express or implied
% version 2000-Sep-10
if (length(N)~=1) | (fix(N) ~= N) | (N < 1)
  error('N must be a scalar positive integer'); 
end
% TODO: test that elements of A are real and positive here?
u = A .^ N;
uprime = N * A .^ (N-1);
v = zeros(size(A));
for ii=0:N
	v = v + A .^ ii ./ factorial(ii);
end
vprime = zeros(size(A));
for ii=1:N
	vprime = vprime + ii .* A .^ (ii-1) ./ factorial(ii);
end
% d(u/v)/dx = (v*du/dx - u*dv/dx)/v^2
eprime = (v .* uprime - u .* vprime) ./ (factorial(N) .* v .^ 2);