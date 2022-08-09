function [s_rlb] = fcn_s_rlb(in_rlb)
    %% in_rlb sorting
    z_r = in_rlb(1:2,1);
    l_r = in_rlb(3,1);
    O_lb = in_rlb(4:9,1);
    h_lb = in_rlb(10,1);
    w_lb = in_rlb(11,1);
    Fi_b_z = in_rlb(12,1);
    s_r_try = in_rlb(13:18,1);
    
    %% calculation
    fcn = @(s_r) F_lb(s_r,z_r,l_r,O_lb,h_lb,w_lb,Fi_b_z);
    s_rlb = fsolve(fcn,s_r_try')';
    
    %% function definition
    function F = F_lb(s_r,z_r,l_r,O_lb,h_lb,w_lb,Fi_b_z)
        % T_F(1,1:4)
        F(1) = cos(s_r(5))*cos(s_r(6))+sin(z_r(2))*(sin(O_lb(5))*cos(z_r(1))+sin(z_r(1))*(cos(Fi_b_z)*cos(O_lb(5))*sin(O_lb(6))+cos(O_lb(5))*cos(O_lb(6))*sin(Fi_b_z)))-cos(z_r(2))*(cos(Fi_b_z)*cos(O_lb(5))*cos(O_lb(6))-cos(O_lb(5))*sin(Fi_b_z)*sin(O_lb(6)));
        F(2) = cos(z_r(1))*(cos(Fi_b_z)*cos(O_lb(5))*sin(O_lb(6))+cos(O_lb(5))*cos(O_lb(6))*sin(Fi_b_z))-cos(s_r(5))*sin(s_r(6))-sin(O_lb(5))*sin(z_r(1));
        F(3) = sin(s_r(5))-cos(z_r(2))*(sin(O_lb(5))*cos(z_r(1))+sin(z_r(1))*(cos(Fi_b_z)*cos(O_lb(5))*sin(O_lb(6))+cos(O_lb(5))*cos(O_lb(6))*sin(Fi_b_z)))-sin(z_r(2))*(cos(Fi_b_z)*cos(O_lb(5))*cos(O_lb(6))-cos(O_lb(5))*sin(Fi_b_z)*sin(O_lb(6)));
        F(4) = s_r(1)-O_lb(1)-h_lb*sin(O_lb(5))+(w_lb*sin(Fi_b_z + O_lb(6))*cos(O_lb(5)))/2-(l_r*sin(O_lb(5))*cos(z_r(1))*cos(z_r(2)))/2-(l_r*cos(Fi_b_z + O_lb(6))*cos(O_lb(5))*sin(z_r(2)))/2-(l_r*cos(Fi_b_z)*cos(O_lb(5))*sin(O_lb(6))*cos(z_r(2))*sin(z_r(1)))/2-(l_r*cos(O_lb(5))*cos(O_lb(6))*sin(Fi_b_z)*cos(z_r(2))*sin(z_r(1)))/2;
        % T_F(2,1:4)
        F(5) = cos(s_r(4))*sin(s_r(6))-cos(z_r(2))*(cos(Fi_b_z)*(cos(O_lb(4))*sin(O_lb(6))+cos(O_lb(6))*sin(O_lb(4))*sin(O_lb(5)))+sin(Fi_b_z)*(cos(O_lb(4))*cos(O_lb(6))-sin(O_lb(4))*sin(O_lb(5))*sin(O_lb(6))))-sin(z_r(2))*(sin(z_r(1))*(cos(Fi_b_z)*(cos(O_lb(4))*cos(O_lb(6))-sin(O_lb(4))*sin(O_lb(5))*sin(O_lb(6)))-sin(Fi_b_z)*(cos(O_lb(4))*sin(O_lb(6))+cos(O_lb(6))*sin(O_lb(4))*sin(O_lb(5))))+cos(O_lb(5))*sin(O_lb(4))*cos(z_r(1)))+cos(s_r(6))*sin(s_r(4))*sin(s_r(5));
        F(6) = cos(s_r(4))*cos(s_r(6))-cos(z_r(1))*(cos(Fi_b_z)*(cos(O_lb(4))*cos(O_lb(6))-sin(O_lb(4))*sin(O_lb(5))*sin(O_lb(6)))-sin(Fi_b_z)*(cos(O_lb(4))*sin(O_lb(6))+cos(O_lb(6))*sin(O_lb(4))*sin(O_lb(5))))-sin(s_r(4))*sin(s_r(5))*sin(s_r(6))+cos(O_lb(5))*sin(O_lb(4))*sin(z_r(1));
        F(7) = cos(z_r(2))*(sin(z_r(1))*(cos(Fi_b_z)*(cos(O_lb(4))*cos(O_lb(6))-sin(O_lb(4))*sin(O_lb(5))*sin(O_lb(6)))-sin(Fi_b_z)*(cos(O_lb(4))*sin(O_lb(6))+cos(O_lb(6))*sin(O_lb(4))*sin(O_lb(5))))+cos(O_lb(5))*sin(O_lb(4))*cos(z_r(1)))-sin(z_r(2))*(cos(Fi_b_z)*(cos(O_lb(4))*sin(O_lb(6))+cos(O_lb(6))*sin(O_lb(4))*sin(O_lb(5)))+sin(Fi_b_z)*(cos(O_lb(4))*cos(O_lb(6))-sin(O_lb(4))*sin(O_lb(5))*sin(O_lb(6))))-cos(s_r(5))*sin(s_r(4));
        F(8) = s_r(2)-O_lb(2)-(l_r*(sin(z_r(2))*(cos(Fi_b_z)*(cos(O_lb(4))*sin(O_lb(6))+cos(O_lb(6))*sin(O_lb(4))*sin(O_lb(5)))+sin(Fi_b_z)*(cos(O_lb(4))*cos(O_lb(6))-sin(O_lb(4))*sin(O_lb(5))*sin(O_lb(6))))-cos(z_r(2))*(sin(z_r(1))*(cos(Fi_b_z)*(cos(O_lb(4))*cos(O_lb(6))-sin(O_lb(4))*sin(O_lb(5))*sin(O_lb(6)))-sin(Fi_b_z)*(cos(O_lb(4))*sin(O_lb(6))+cos(O_lb(6))*sin(O_lb(4))*sin(O_lb(5))))+cos(O_lb(5))*sin(O_lb(4))*cos(z_r(1)))))/2-(w_lb*(cos(Fi_b_z)*(cos(O_lb(4))*cos(O_lb(6))-sin(O_lb(4))*sin(O_lb(5))*sin(O_lb(6)))-sin(Fi_b_z)*(cos(O_lb(4))*sin(O_lb(6))+cos(O_lb(6))*sin(O_lb(4))*sin(O_lb(5)))))/2+h_lb*cos(O_lb(5))*sin(O_lb(4));
        % T_F(3,1:4)
        F(9) = sin(s_r(4))*sin(s_r(6))-cos(z_r(2))*(cos(Fi_b_z)*(sin(O_lb(4))*sin(O_lb(6))-cos(O_lb(4))*cos(O_lb(6))*sin(O_lb(5)))+sin(Fi_b_z)*(cos(O_lb(6))*sin(O_lb(4))+cos(O_lb(4))*sin(O_lb(5))*sin(O_lb(6))))-sin(z_r(2))*(sin(z_r(1))*(cos(Fi_b_z)*(cos(O_lb(6))*sin(O_lb(4))+cos(O_lb(4))*sin(O_lb(5))*sin(O_lb(6)))-sin(Fi_b_z)*(sin(O_lb(4))*sin(O_lb(6))-cos(O_lb(4))*cos(O_lb(6))*sin(O_lb(5))))-cos(O_lb(4))*cos(O_lb(5))*cos(z_r(1)))-cos(s_r(4))*cos(s_r(6))*sin(s_r(5));
        F(10) = cos(s_r(6))*sin(s_r(4))-cos(z_r(1))*(cos(Fi_b_z)*(cos(O_lb(6))*sin(O_lb(4))+cos(O_lb(4))*sin(O_lb(5))*sin(O_lb(6)))-sin(Fi_b_z)*(sin(O_lb(4))*sin(O_lb(6))-cos(O_lb(4))*cos(O_lb(6))*sin(O_lb(5))))+cos(s_r(4))*sin(s_r(5))*sin(s_r(6))-cos(O_lb(4))*cos(O_lb(5))*sin(z_r(1));
        F(11) = cos(s_r(4))*cos(s_r(5))-sin(z_r(2))*(cos(Fi_b_z)*(sin(O_lb(4))*sin(O_lb(6))-cos(O_lb(4))*cos(O_lb(6))*sin(O_lb(5)))+sin(Fi_b_z)*(cos(O_lb(6))*sin(O_lb(4))+cos(O_lb(4))*sin(O_lb(5))*sin(O_lb(6))))+cos(z_r(2))*(sin(z_r(1))*(cos(Fi_b_z)*(cos(O_lb(6))*sin(O_lb(4))+cos(O_lb(4))*sin(O_lb(5))*sin(O_lb(6)))-sin(Fi_b_z)*(sin(O_lb(4))*sin(O_lb(6))-cos(O_lb(4))*cos(O_lb(6))*sin(O_lb(5))))-cos(O_lb(4))*cos(O_lb(5))*cos(z_r(1)));
        F(12) = s_r(3)-O_lb(3)-(l_r*(sin(z_r(2))*(cos(Fi_b_z)*(sin(O_lb(4))*sin(O_lb(6))-cos(O_lb(4))*cos(O_lb(6))*sin(O_lb(5)))+sin(Fi_b_z)*(cos(O_lb(6))*sin(O_lb(4))+cos(O_lb(4))*sin(O_lb(5))*sin(O_lb(6))))-cos(z_r(2))*(sin(z_r(1))*(cos(Fi_b_z)*(cos(O_lb(6))*sin(O_lb(4))+cos(O_lb(4))*sin(O_lb(5))*sin(O_lb(6)))-sin(Fi_b_z)*(sin(O_lb(4))*sin(O_lb(6))-cos(O_lb(4))*cos(O_lb(6))*sin(O_lb(5))))-cos(O_lb(4))*cos(O_lb(5))*cos(z_r(1)))))/2-(w_lb*(cos(Fi_b_z)*(cos(O_lb(6))*sin(O_lb(4))+cos(O_lb(4))*sin(O_lb(5))*sin(O_lb(6)))-sin(Fi_b_z)*(sin(O_lb(4))*sin(O_lb(6))-cos(O_lb(4))*cos(O_lb(6))*sin(O_lb(5)))))/2-h_lb*cos(O_lb(4))*cos(O_lb(5));
    end
end