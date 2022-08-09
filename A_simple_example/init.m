clear; close all;

% Initialize symbols
syms a ksb ksc dl0c msb msc zeta1 zeta2 real positive
h1 = [0 -1 0 1];
h2 = sqrt(2)/2 * [-1 -1 1 1];
h3 = sqrt(2)/2 * [1 -1 -1 1];

% Initialize matrices
Ks = diag([ksb ksc ksc]);
L0i = 1/a * diag([1 sqrt(2)/2 sqrt(2)/2]);
Pi = [zeros(2) eye(2) zeros(2) eye(2) zeros(2) eye(2)];
H = zeros(3*4,3); H(1:4,1) = h1'; H(5:8,2) = h2'; H(9:end,end) = h3';
Ss = eye(3); Sa = eye(3);

% From previous FEM
kk = sqrt(2)/2*ksc/a * (dl0c/(sqrt(2)*a-dl0c) + 1);
K = diag([kk ksb/a+kk]);
M = 2 * (a*msb + 2*msc*(sqrt(2)*a - dl0c)) * eye(2);

%% Compute eigenmode realization
[U,Om2] = eig(M\K)
Om = Om2.^(1/2);
u1 = U(:,1); u2 = U(:,2); U(:,1) = u2; U(:,2) = u1;

%% Damping
Del = diag(2*[zeta1*Om(1,1) zeta2*Om(2,2)])

%% Simplified by hand
dLam = 2*sqrt(2)*a*((sqrt(2)*msb + 4*msc)*a^2 - (msb + 4*sqrt(2)*msc)*dl0c*a + 2*dl0c^2*msc);

% Jacobians
Ja = Pi*H*Sa
Js = Ss*H'*Pi'

%% Create modal state space model (not almost-balanced for clarity)
A = [zeros(2) eye(2); -Om2 -Del]
B = [zeros(2,3); U'*Ja]
C = [Ks*L0i*Js*U zeros(3,2)]
D = zeros(3);

%% Compute symbolic Gramians
% R = [B A*B A^2*B A^3*B]; % ctrb matrix (if full rank, sys is controllable)
% Q = [C; C*A; C*A^2; C*A^3]; % obsv matrix

% Define symbolic Gramians
syms wc11 wc12 wc13 wc14 wc21 wc22 wc23 wc24 wc31 wc32 wc33 wc34 wc41 wc42 wc43 wc44
syms wo11 wo12 wo13 wo14 wo21 wo22 wo23 wo24 wo31 wo32 wo33 wo34 wo41 wo42 wo43 wo44
Wc = [wc11 wc12 wc13 wc14; wc21 wc22 wc23 wc24; wc31 wc32 wc33 wc34; wc41 wc42 wc43 wc44];
Wo = [wo11 wo12 wo13 wo14; wo21 wo22 wo23 wo24; wo31 wo32 wo33 wo34; wo41 wo42 wo43 wo44];

% State Lyapunov equations
eqsWc = A*Wc + Wc*A' + B*B';
eqsWo = A'*Wo + Wo*A + C'*C;

eqsWc = eqsWc(:) == zeros(16,1); % controllability Gramian
eqsWo = eqsWo(:) == zeros(16,1); % observabilty Gramian

%% Solve Lyapunov equations symbollically (cannot solve)
LyapWc = solve(eqsWc,Wc(:),'ReturnConditions',true);
LyapWo = solve(eqsWo,Wo(:),'ReturnConditions',true);

%% Results
rWc = [LyapWc.wc11 LyapWc.wc12 LyapWc.wc13 LyapWc.wc14; LyapWc.wc21 ...
       LyapWc.wc22 LyapWc.wc23 LyapWc.wc24; LyapWc.wc31 LyapWc.wc32 ...
       LyapWc.wc33 LyapWc.wc34; LyapWc.wc41 LyapWc.wc42 LyapWc.wc43 ...
       LyapWc.wc44];
rWo = [LyapWo.wo11 LyapWo.wo12 LyapWo.wo13 LyapWo.wo14; LyapWo.wo21 ...
       LyapWo.wo22 LyapWo.wo23 LyapWo.wo24; LyapWo.wo31 LyapWo.wo32 ...
       LyapWo.wo33 LyapWo.wo34; LyapWo.wo41 LyapWo.wo42 LyapWo.wo43 ...
       LyapWo.wo44];

%% Reorder equations based on length (for clarity)
eqlenc = zeros(16,1); eqleno = zeros(16,1);
for i = 1:16
    eqlenc(i) = length(char(eqsWc(i)));
    eqleno(i) = length(char(eqsWo(i)));
end
[~,ic] = sort(eqlenc); [~,io] = sort(eqleno);
eqsWc = eqsWc(ic); eqsWo = eqsWo(io);
