void op_imag( float* out, float* v )
{
	int i;
	float x2, y;
	const float threehalfs = 1.5f;
  float s = v[0]*v[0] + v[1]*v[1] + v[2]*v[2];

	x2 = s * 0.5f;
	y  = s;
	i  = * ( int * ) &y;                       // evil floating point bit level hacking
	i  = 0x5f3759df - ( i >> 1 );               // what the fuck? 
	y  = * ( float * ) &i;
	y  = y * ( threehalfs - ( x2 * y * y ) );   // 1st iteration
	y  = y * ( threehalfs - ( x2 * y * y ) );   // 2nd iteration, this can be removed

	*out = y;
}
	
/** 4-Vector and 4-Vector Multiply */
void op_vvm4 (float* out, float* v, float* u)
{
    for (int i = 0; i < 4; i++)
        out[i] = v[i] * u[i];
}

/** Scalar and 4-Vector Multiply */
void op_svm4 (float* out, float s, float* v)
{
    for (int i = 0; i < 4; i++)
        out[i] = s * v[i];
}

/** Scalar and 3-Vector Multiply */
void op_svm3 (float* out, float s, float* v)
{
    for (int i = 0; i < 3; i++)
        out[i] = s * v[i];
}

/** Dot Product 4 */
void op_dp4 (float* out, float* v, float* u)
{
    float sum = 0;
    for (int i = 0; i < 4; i++)
        sum += v[i] * u[i];
    *out = sum;
}

/** Dot Product 3 */
void op_dp3 (float* out, float* v, float* u)
{
    float sum = 0;
    for (int i = 0; i < 3; i++)
        sum += v[i] * u[i];
    *out = sum;
}

/** Add 4-Vector */
void op_addv4 (float* out, float* v, float* u)
{
    for (int i = 0; i < 4; i++)
        out[i] = v[i] + u[i];
}

/** Add 3-Vector */
void op_addv3 (float* out, float* v, float* u)
{
    for (int i = 0; i < 3; i++)
        out[i] = v[i] + u[i];
}

/** Subtract 4-Vector */
void op_subv4 (float* out, float* v, float* u)
{
    for (int i = 0; i < 4; i++)
        out[i] = v[i] - u[i];
}

/** Subtract 3-Vector */
void op_subv3 (float* out, float* v, float* u)
{
    for (int i = 0; i < 3; i++)
        out[i] = v[i] - u[i];
}

/** Clip 4-Vector */
void op_clpv4 (float* v)
{
    for (int i = 0; i < 4; i++)
    {        
        if (v[i] < 0.0f) v[i] = 0.0f;
        if (v[i] > 1.0f) v[i] = 1.0f;
    }
}

/** Clip 3-Vector */
void op_clpv3 (float* v)
{
    for (int i = 0; i < 4; i++)
    {        
        if (v[i] < 0.0f) v[i] = 0.0f;
        if (v[i] > 1.0f) v[i] = 1.0f;
    }
}

/** Clip Scalar */
void op_clps (float* s)
{
    if (*s < 0.0f) *s = 0.0f;
    if (*s > 1.0f) *s = 1.0f;
}
