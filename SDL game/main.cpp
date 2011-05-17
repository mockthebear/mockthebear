#include <GL/glut.h>
#include <math.h>
#include <time.h>
#include <iostream>

void onDisplay();
void onKeyDown(unsigned char key, int x, int y);
void onKeyUp(unsigned char key, int x, int y);
void onUpdate(int value);

struct Paddle
{
	int x;
	int y;
	int width;
	int height;
};

struct Ball
{
	int x;
	int y;
	int width;
	int height;
	int vel_x;
	int vel_y;
};

struct Paddle bat1;
struct Paddle bat2;
struct Ball ball;

int key_w = 0;
int key_s = 0;
int key_i = 0;
int key_k = 0;
int start = 1;
int speed = 5;

int p1 = 0;
int p2 = 0;

float ballspeed = 8;
float batspeed = 5;

bool is_inside(float x, float y, float dx, float dy, float dw, float dh)
{
	return x >= dx & x <= dx + dw & y >= dy & y <= dy + dh;
}

bool is_intersecting(float x, float y, float w, float h, float dx, float dy, float dw, float dh)
{
	return is_inside(x, y, dx, dy, dw, dh)
		|| is_inside(x + w, y, dx, dy, dw, dh)
		|| is_inside(x, y + h, dx, dy, dw, dh)
		|| is_inside(x + w, y + h, dx, dy, dw, dh);
}

int main(int argc, char *argv[])
{
	glutInit(&argc, argv);

	srand(time(NULL));

	glutInitWindowSize(640, 480);
	glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGBA);
	glutCreateWindow("Pong");

	glClearColor(0.0, 0.0, 0.0, 0.0);

	gluOrtho2D(0, 640, 480, 0);

	bat1.width = 20;
	bat1.height = 100;
	bat1.x = 30;
	bat1.y = (480 - bat1.height) / 2;

	bat2.width = 20;
	bat2.height = 100;
	bat2.x = 640 - 30 - bat2.width;
	bat2.y = (480 - bat2.height) / 2;

	ball.width = 20;
	ball.height = 20;
	ball.x = (640 - ball.width) / 2;
	ball.y = (480 - ball.height) / 2;
	ball.vel_x = 0;
	ball.vel_y = 0;

	glutDisplayFunc(onDisplay);
	glutKeyboardFunc(onKeyDown);
	glutKeyboardUpFunc(onKeyUp);
	onUpdate(0);

	glutMainLoop();
	return 0;
}

void onDisplay()
{
	glClear(GL_COLOR_BUFFER_BIT);

	glBegin(GL_POLYGON);
		glVertex2f(bat1.x,		bat1.y);
		glVertex2f(bat1.x + bat1.width,	bat1.y);
		glVertex2f(bat1.x + bat1.width,	bat1.y + bat1.height);
		glVertex2f(bat1.x,		bat1.y + bat1.height);
	glEnd();

	glBegin(GL_POLYGON);
		glVertex2f(bat2.x,		bat2.y);
		glVertex2f(bat2.x + bat2.width,	bat2.y);
		glVertex2f(bat2.x + bat2.width,	bat2.y + bat2.height);
		glVertex2f(bat2.x,		bat2.y + bat2.height);
	glEnd();

	glBegin(GL_POLYGON);
		glVertex2f(ball.x,		ball.y);
		glVertex2f(ball.x + ball.width,	ball.y);
		glVertex2f(ball.x + ball.width,	ball.y + ball.height);
		glVertex2f(ball.x,		ball.y + ball.height);
	glEnd();

	glutSwapBuffers();
}

void onKeyDown(unsigned char key, int x, int y)
{
	switch (key) {
	case 'w':
		key_w = 1;
		break;
	case 's':
		key_s = 1;
		break;
	case 'i':
		key_i = 1;
		break;
	case 'k':
		key_k = 1;
		break;
	case ' ':
		if (start == 1) {
			start = 0;
			ball.vel_x = 1;
			if (rand()%2 == 0) {
				ball.vel_x *= -1;
			}
			ball.vel_y = rand()%2-1;
			if (ball.vel_y == 0) {
				ball.vel_y = 1;
			}
		}
		break;
	}
}

void onKeyUp(unsigned char key, int x, int y)
{
	switch (key) {
	case 'w':
		key_w = 0;
		break;
	case 's':
		key_s = 0;
		break;
	case 'i':
		key_i = 0;
		break;
	case 'k':
		key_k = 0;
		break;	
	}
}

void onUpdate(int value)
{
	if (key_w == 1) {
		bat1.y -= (float)(1 * batspeed);
	}
	if (key_s == 1) {
		bat1.y += (float)(1 * batspeed);
	}
	if (key_i == 1) {
		bat2.y -= (float)(1 * batspeed);
	}
	if (key_k == 1) {
		bat2.y += (float)(1 * batspeed);
	}

	if (bat1.y < 0) {
		bat1.y = 0;
	}
	if (bat1.y+bat1.height > 480) {
		bat1.y = 480-bat1.height;
	}
	if (bat2.y < 0) {
		bat2.y = 0;
	}
	if (bat2.y+bat2.height > 480) {
		bat2.y = 480-bat2.height;
	}

	ball.x += ball.vel_x * ballspeed;
	ball.y += ball.vel_y * ballspeed;

	if (ball.y < 0) {
		ball.y = 0;
		ball.vel_y = 1;
	}
	if (ball.y+ball.height > 480) {
		ball.y = 480-ball.height;
		ball.vel_y = -1;
	}

	if (ball.x < 0) {
		start = 1;
		ball.x = (640 - ball.width) / 2;
		ball.y = (480 - ball.height) / 2;
		ball.vel_y = 0;
		ball.vel_x = 0;
		std::cout << std::endl;
	}
	if (ball.x+ball.width > 640) {
		start = 1;
		speed = 5;
		ball.x = (640 - ball.width) / 2;
		ball.y = (480 - ball.height) / 2;
		ball.vel_y = 0;
		ball.vel_x = 0;
	}

	if (is_intersecting(ball.x, ball.y, ball.width, ball.height, bat1.x, bat1.y, bat1.width, bat1.height)) {
		ball.vel_x = 1;
		speed += 1;
	}

	if (is_intersecting(ball.x, ball.y, ball.width, ball.height, bat2.x, bat2.y, bat2.width, bat2.height)) {
		ball.vel_x = -1;
		speed += 1;
	}

	glutPostRedisplay();
	glutTimerFunc(15, onUpdate, 0);
}
