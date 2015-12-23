#ifndef __SHADER_OPS_H
#define __SHADER_OPS_H

void op_imag( float* out, float* v );
void op_vvm4 (float* out, float* v, float* u);
void op_svm4 (float* out, float s, float* v);
void op_svm3 (float* out, float s, float* v);
void op_dp4 (float* out, float* v, float* u);
void op_dp3 (float* out, float* v, float* u);
void op_addv4 (float* out, float* v, float* u);
void op_addv3 (float* out, float* v, float* u);
void op_subv4 (float* out, float* v, float* u);
void op_subv3 (float* out, float* v, float* u);
void op_clpv4 (float* v);
void op_clpv3 (float* v);
void op_clps (float* s);

#endif
