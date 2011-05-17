#include <GL/gl.h>
#include <GL/glut.h>
#include <SDL/SDL.h>

#include <iostream>
#include <stdlib.h>
#include <vector>

#include "object.h"

void create_window(int width, int height, int bpp, bool fullscreen);
void draw_table(int x, int y, int id);
void process_events();

SDL_Surface* screen;
std::vector<Object*> objects;
bool eml = false;
bool emr = false;

int ampl = 2;

float color[][3] = {
	{0.0f, 1.0f, 0.0f}, // green
	{1.0f, 0.0f, 0.0f}, //red
	{0.7f, 0.7f, 0.7f},
	{1.0f, 1.0f, 0.0f}, // amarelo
	{0.0f, 0.0f, 1.0f}, // blue
	{0.5f, 0.5f, 0.5f},
	{0.6f, 0.6f, 1.0f},
	{0.0f, 0.0f, 0.3f},
	{0.0f, 0.0f, 0.2f},
	{1.0f, 0.6f, 0.0f}, // laranja

};

int letras[][10][10] = {
	{
		{0,0,0,0,5,5,0,0,0,0},
		{0,0,0,0,5,5,0,0,0,0},
		{0,0,0,0,7,7,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0},
		{0,0,0,6,6,6,6,0,0,0},
		{0,0,0,6,6,6,6,0,0,0},
		{0,0,0,6,6,6,6,0,0,0},
		{0,0,3,3,3,3,3,3,0,0},
		{0,3,3,3,3,3,3,3,3,0},
		{3,3,3,3,3,3,3,3,3,3},
	},
	{
		{0,0,0,0,2,2,0,0,0,0},
		{0,0,0,0,2,2,0,0,0,0},
		{0,0,0,0,1,1,0,0,0,0},
		{0,0,0,0,1,1,0,0,0,0},
		{0,0,1,1,1,1,1,1,0,0},
		{0,0,1,1,1,1,1,1,0,0},
		{0,1,1,1,1,1,1,1,1,0},
		{3,3,3,3,1,1,3,3,3,3},
		{3,2,2,3,0,0,3,2,2,3},
		{3,4,4,3,0,0,3,4,4,3},
	},
	{
		{0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,5,5,0,0,0,0},
		{0,0,0,0,5,5,0,0,0,0},
		{0,0,0,0,7,7,0,0,0,0},
		{0,0,0,0,7,7,0,0,0,0},
		{0,0,0,0,8,8,0,0,0,0},
		{0,0,0,0,7,7,0,0,0,0},
		{0,0,0,0,9,9,0,0,0,0},
	},
	{
		{0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0},
		{0,0,4,0,0,0,0,4,0,0},
		{0,0,0,10,0,0,10,0,0,0},
		{0,0,0,0,2,2,0,0,0,0},
		{0,0,0,0,2,2,0,0,0,0},
		{0,0,0,10,0,0,10,0,0,0},
		{0,0,4,0,0,0,0,4,0,0},
		{0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0},
	},
};
Object* objectk;
int main(int argc,char* argv[])
{
	create_window(300, 300, 8, false);
	while (true) {
		process_events();
	}
	return 0;
}
Object* getObjMain()
{
    std::vector<Object*>::iterator iter;
	for (iter = objects.begin(); iter != objects.end(); ++iter) {
	Object* object = *iter;
           if (object->get_name() == "main")
              {
               return object;
               break;
               }
        }
}
void create_window(int width, int height, int bpp, bool fullscreen)
{
	if (SDL_Init(SDL_INIT_VIDEO) < 0) {
		std::cout << "SDL could not be initialized!" << std::endl;
		exit(0);
	}

	int flags = SDL_SWSURFACE | SDL_OPENGL;
	if (fullscreen) {
		flags = flags | SDL_FULLSCREEN;
	}

	screen = SDL_SetVideoMode(width, height, bpp, flags);
	if (screen == NULL) {
		std::cout << "SDL screen could not be created!" << std::endl;
		exit(0);
	}

	glViewport(0, 0, width, height);
	glClearColor(0, 0, 0, 0);
	glMatrixMode(GL_PROJECTION);
	//glutKeyboardFunc(keyboard);

	glLoadIdentity();
	gluOrtho2D(0.0f, width, height, 0.0f);
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();

	objects.push_back(new Object(10, 250, 2));
	std::vector<Object*>::iterator iter;
	for (iter = objects.begin(); iter != objects.end(); ++iter) {
        Object* object = *iter;
        object->set_name("main");
    }
    objectk =  getObjMain();
	atexit(SDL_Quit);
}

void draw_table(int xa,int ya, int id)
{
	//object->set_x(object->get_x()-1);
	//object->set_y(object->get_y()-1);
	glBegin(GL_POINTS);
	glColor4f(0.0f, 1.0f, 0.0f, 0.5f);
	for (int y=1; y<=10; y++) {
		for (int x=1; x<=10; x++) {
			int idq = letras[id-1][y-1][x-1];
			if (idq != 0) {
				glColor4f(
					color[idq-1][0],
					color[idq-1][1],
					color[idq-1][2],
					0.5f
				);
				for (int sx=1; sx<=ampl; sx++) {
					for (int sy=1; sy<=ampl; sy++) {
						glVertex2d(((x*2)+sx)+xa, ((y*2)+sy)+ya);
					}
				}
			}
		}
	}
	glEnd();
}

int ax,ay,aid;
bool add;
void process_events()
{
	SDL_Event event;
	glClear(GL_COLOR_BUFFER_BIT);
	glDisable(GL_TEXTURE_2D);
	std::vector<Object*>::iterator iter;
	for (iter = objects.begin(); iter != objects.end(); ++iter) {
		Object* object = *iter;
		int id = object->get_id();
		int y = object->get_y();
		int x = object->get_x();
		bool deleted = false;
        if (id == 3){
            if (y <= 10){
                ax = x;
                ay = y;
                aid = 4;
                add = true;
                delete[] &iter;
                deleted = true;
                //break;
			}else{
				object->set_y(object->get_y()-3);
			}

       }
       if (id == 4){
            int cyc = object->get_cycle();
            if (cyc > 1)
            {
               object->set_cycle(cyc-1);
            }else{
                delete[] &iter;
                deleted = true;
            }
       }
    glBegin(GL_POINTS);
	glColor4f(1.0f, 1.0f, 1.0f, 0.5f);
	glVertex2d(100, 100);
    glEnd();
        if (!deleted)
        {
          draw_table(x,y,id);
        }
	}
	if (add){	objects.push_back(new Object(ax, ay, aid));}
	if (eml)
	{
       Object* object = getObjMain();
	   object->set_x(object->get_x()-2);
	   if (object->get_x() <= -5*ampl){object->set_x(300-(5*ampl));}
    }else if(emr){
       Object* object = getObjMain();
	   object->set_x(object->get_x()+2);
	   if (object->get_x() >= 300-(5*ampl)){object->set_x(-5*ampl);}
    }
	glEnable(GL_TEXTURE_2D);
	SDL_GL_SwapBuffers();
	while (SDL_PollEvent(&event) != 0) {
		switch (event.type) {
			case SDL_KEYUP:
            	switch(event.key.keysym.sym) {
				case SDLK_LEFT:
					eml = false;
					break;
				case SDLK_RIGHT:
					emr = false;
					break;

			}
		 	break;
            case SDL_KEYDOWN:
				switch(event.key.keysym.sym) {
					case SDLK_SPACE:

						objects.push_back(new Object(objectk->get_x(), objectk->get_y()-(10*ampl), 3));
                        break;
					case SDLK_LEFT:
                        eml = true;
                        break;
					case SDLK_RIGHT:
                        emr = true;
                        break;
			  };
              break;
			case SDL_QUIT:
				exit(0);
				break;
		}
	}
}

