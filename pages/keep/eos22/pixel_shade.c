#include "shader_ops.h"

void pixel_shade(float* out_colors, float* pos, float* norm, float* lightPosition, float* lightColor)
{
    float origin[3] = {0.0f, 0.0f, 0.0f};

    /** Initialize */
    out_colors[0] = 0.0f;
    out_colors[1] = 0.0f;
    out_colors[2] = 0.0f;
    out_colors[3] = 0.0f;
    
    /** Normalized interpolated normal */
    float N[3];
    float N_imag; 
    
    /** Normalize fragment normal vector */
    op_imag(&N_imag, norm);
    op_svm3(N, N_imag, norm);
    
    /** Calculate lighting influence on the vertex */
    //Vectors
    float L[3];
    float V[3];
    float L_plus_V[3];
    float amb_plus_diff_plus_spec[4];
    
    //Scalars
    float L_mag_squared;
    float L_imag;
    float L_dot_N;
    float L_plus_V_imag;
    float L_plus_V_dot_N;
    float L_plus_V_dot_N_pow;
    
    float att_total;
    float att_lin;
    float att_quad;
    float inv_att;
    
    //Diffuse and Specular RGB
    float diffuse[3];
    float specular[3];

    //L = Vertex position to light position
    op_subv3(L, lightPosition, pos);
    //Normalize L -> V vector
    op_imag(&L_imag, L);
    op_svm3(L, L_imag, L);
    
    //Dot L with pixel N
    op_dp3(&L_dot_N, L, N);

    //Clamp L_dot_N
    op_clps(&L_dot_N);
    //printf("%d\n", (int)(L_dot_N*255.0f));
    
    //Calculate and add diffuse lighting component
    op_svm4(diffuse, L_dot_N, lightColor);
                
    //Calculate vector to origin coordinates
    op_subv3(V, origin, pos);
    op_subv3(L, lightPosition, pos);
    
    op_addv3(L_plus_V, L, V);
    op_imag(&L_plus_V_imag, L_plus_V);
    op_svm3(L_plus_V, L_plus_V_imag, L_plus_V);
    op_dp3(&L_plus_V_dot_N, L_plus_V, N);

    //Clamp L_plus_V_dot_N
    op_clps(&L_plus_V_dot_N);
    //printf("%d %d %d\n", (int)(L_plus_V[0]*255.0f), (int)(L_plus_V[1]*255.0f), (int)(L_plus_V[2]*255.0f));
    
    //Specular power function
    L_plus_V_dot_N_pow = L_plus_V_dot_N * L_plus_V_dot_N;
    L_plus_V_dot_N_pow = L_plus_V_dot_N_pow * L_plus_V_dot_N_pow;
    L_plus_V_dot_N_pow = L_plus_V_dot_N_pow * L_plus_V_dot_N_pow;
    L_plus_V_dot_N_pow = L_plus_V_dot_N_pow * L_plus_V_dot_N_pow;
    L_plus_V_dot_N_pow = L_plus_V_dot_N_pow * L_plus_V_dot_N_pow;
    L_plus_V_dot_N_pow = L_plus_V_dot_N_pow * L_plus_V_dot_N_pow;
    L_plus_V_dot_N_pow = L_plus_V_dot_N_pow * L_plus_V_dot_N_pow;
    L_plus_V_dot_N_pow = L_plus_V_dot_N_pow * L_plus_V_dot_N_pow;
    op_svm4(specular, L_plus_V_dot_N_pow, lightColor);
    //printf("%d\n", (int)(L_plus_V_dot_N_pow*255.0f));
    
    //Add specular and diffuse components
    op_addv4(amb_plus_diff_plus_spec, diffuse, specular);

    //Apply attenuation
    op_svm4(amb_plus_diff_plus_spec, L_imag, amb_plus_diff_plus_spec);
    
    op_addv4(out_colors, out_colors, amb_plus_diff_plus_spec);
    
    op_clpv4(out_colors);
}		
