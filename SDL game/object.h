#ifndef OBJECT_H
#define OBJECT_H

class Object
{
	public:
		Object(int x, int y, int id);
		~Object();

		void set_id(int value);
		void set_x(int value);
		void set_y(int value);
		void set_dir(bool value);
        void set_cycle(int value);
        void set_name(const char* value);
        
		int get_id();
		int get_x();
		int get_y();
		int get_cycle();
		bool get_dir();
		const char* get_name();

	private:
		int id;
		int x;
		int y;
		int cycle;
		bool dir;
		const char* name;
};

#endif

