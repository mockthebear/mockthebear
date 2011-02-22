#include <GL/gl.h>
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

int ampl = 2;

float color[][3] = {
	{0.0f, 1.0f, 0.0f},
	{1.0f, 0.0f, 0.0f},
	{0.7f, 0.7f, 0.7f},
	{1.0f, 1.0f, 0.0f},
	{0.0f, 0.0f, 1.0f},
	{0.5f, 0.5f, 0.5f},
	{0.6f, 0.6f, 1.0f},
	{0.0f, 0.0f, 0.3f},
	{0.0f, 0.0f, 0.2f},
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
};

int main(int argc,char* argv[])
{
	create_window(300, 300, 8, false);
	while (true) {
		process_events();
	}
	return 0;
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
	glOrtho(0, width, height, 0, -1, 1);
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();

	objects.push_back(new Object(0, 300, 2));

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

void process_events()
{
	SDL_Event event;
	glClear(GL_COLOR_BUFFER_BIT);

	std::vector<Object*>::iterator iter;
	for (iter = objects.begin(); iter != objects.end(); ++iter) {
		Object* object = *iter;
		int id = object->get_id();
		int y = object->get_y();
		int x = object->get_x();
		bool deleted = false;
        if (id == 3){
            if (y <= 30){
                delete[] &iter;
                deleted = true;
			}else{
				object->set_y(object->get_y()-1);
			}elseif (id == 4){
                object->set_x(object->get_x()+1);
			}
        }
        if (!deleted)
        {
          draw_table(x,y,id);
        }
	}

	SDL_GL_SwapBuffers();
	while (SDL_PollEvent(&event) != 0) {
		switch (event.type) {
		case SDL_KEYDOWN:
			switch(event.key.keysym.sym) {
				case SDLK_SPACE:
					objects.push_back(new Object(100, 100, 3));
					break;
			};
			break;
		case SDL_QUIT:
			exit(0);
			break;
		}
	}
}

