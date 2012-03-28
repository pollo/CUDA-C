#include <Python.h>
#include <numpy/arrayobject.h>
#include <stdlib.h>
#include <stdio.h>
#include <math.h>

extern void init();
extern void botrix_index(float* tempday, float* precday, int n, float *output);
//extern int huglin (float* T_MAX, float* T_AVG, float* CUMULANT, float* O, int height, int width, float flag_value);

static PyObject *pybotrixindex_botrix_index(PyObject *self, PyObject *args, PyObject *keywds)
{

	/* Function keywords : Describes Python Fucntion inputs*/
	static char *kwlist[] = {"tempday", "precday", NULL}; // NULL is a sentinel

	PyObject *tempday  = NULL;
	PyObject *__py_tempday  = NULL;
	
	PyObject *precday  = NULL;
	PyObject *__py_precday  = NULL;

	PyObject *__py_OUT  = NULL;

	/* Parse function parameters */
 	if (!PyArg_ParseTupleAndKeywords(args, keywds, "OO", kwlist,
					 &precday, &tempday))
		 return NULL;

	/* Convert imput python object into "contiguous C" python object  */
	__py_tempday = PyArray_FROM_OTF(tempday, NPY_FLOAT, NPY_IN_ARRAY);
  	if (__py_tempday == NULL) 
		return NULL;

 	__py_precday = PyArray_FROM_OTF(precday, NPY_FLOAT, NPY_IN_ARRAY);
  	if (__py_precday == NULL) 
		return NULL;
	
	//Get Dims
	npy_intp size = PyArray_DIM(__py_tempday, 0);
	
	/* Point into data */
	float* __py_tempday_values  = (float *) PyArray_DATA(__py_tempday);
  	float* __py_precday_values  = (float *) PyArray_DATA(__py_precday);

	/* Build output numpy array */
	npy_intp OUT_dims[1];
 	OUT_dims[0] = size;

  	__py_OUT = PyArray_SimpleNew(1, OUT_dims, NPY_FLOAT); /* build array */
  	float* __py_OUT_values = (float *) PyArray_DATA(__py_OUT); /* Point into data */

	botrix_index (__py_precday_values, __py_tempday_values, size, __py_OUT_values);
  
  	/* garbage collector deallocation */
	Py_DECREF(__py_precday);
  	Py_DECREF(__py_tempday);

  	return Py_BuildValue("N", __py_OUT); 
}


/* Method table */
static PyMethodDef pybotrixindex_methods[] = {
  {"botrix_index",
   (PyCFunction)pybotrixindex_botrix_index, METH_VARARGS | METH_KEYWORDS, ""},  
  {NULL, NULL}
};


/* Init */
void initpybotrixindex()
{
  Py_InitModule3("pybotrixindex", pybotrixindex_methods, "");
  import_array();
  init();
}
