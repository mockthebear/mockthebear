#include "object.h"
                  //
Object::Object(int x=0, int y=0, int id=0)
{
	set_id(id);
	set_x(x);
	set_y(y);
	set_dir(false);
	cycle = 2;
	
}

Object::~Object()
{

}

void Object::set_id(int value)
{
	id = value;
}

void Object::set_dir(bool value)
{
	dir = value;
}

void Object::set_x(int value)
{
	x = value;
}

void Object::set_y(int value)
{
	y = value;
}
void Object::set_name(const char* value)
{
	name = value;
}
void Object::set_cycle(int value)
{
	cycle = value;
}
int Object::get_cycle()
{
	return cycle;
}

int Object::get_id()
{
	return id;
}

int Object::get_x()
{
	return x;
}

int Object::get_y()
{
	return y;
}
bool Object::get_dir()
{
	return dir;
}
const char* Object::get_name()
{
	return name;
}
