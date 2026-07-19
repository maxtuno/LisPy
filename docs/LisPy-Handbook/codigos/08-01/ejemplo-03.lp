(py:run "from scipy.integrate import solve_ivp; import numpy as np
def robot_dyn(t, state, m1, m2, l1, l2, g):
    t1, t2, dt1, dt2 = state
    M11 = m1*l1**2 + m2*(l1**2+l2**2+2*l1*l2*np.cos(t2))
    M12 = m2*(l2**2 + l1*l2*np.cos(t2))
    M = np.array([[M11, M12], [M12, m2*l2**2]])
    c = m2*l1*l2*np.sin(t2)
    C = np.array([[-c*dt2, -c*(dt1+dt2)], [c*dt1, 0]])
    G = np.array([[(m1*l1+m2*l1)*g*np.cos(t1)+m2*l2*g*np.cos(t1+t2)],
                  [m2*l2*g*np.cos(t1+t2)]])
    q_ddot = np.linalg.solve(M, -C@np.array([[dt1],[dt2]]) - G)
    return [dt1, dt2, q_ddot[0,0], q_ddot[1,0]]
sol = solve_ivp(robot_dyn, [0,10], [np.pi/2,0,0,0],
                args=(1,1,1,1,9.81), method='RK45', max_step=0.01)")
