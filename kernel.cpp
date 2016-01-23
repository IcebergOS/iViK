/* Copyright 2016 Iceberg OS

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/

//=============================================================================
// ■ kernel.c
//-----------------------------------------------------------------------------
//   这个文件是干什么的？
//=============================================================================

#include "config.h"

#include "Basic/types.h"
#include "Basic/io.h"
#include "Basic/memory.h"

/*	debug	*/
#include "Basic/debug.h"

//---------------------------------------------------------------------------
// ● Multiarch初始化
//---------------------------------------------------------------------------
void arch_init () {

	Memory mem = Memory();

	return;
}

//---------------------------------------------------------------------------
// ● 内核IDLE
//---------------------------------------------------------------------------
void idle () {

#ifdef DEBUG
	debugputchar('K');
#endif

	IO io = IO();
	for (;;) {
		io.cpu_hlt ();	// 挂起
	}

	return;
}

extern "C" {
//---------------------------------------------------------------------------
// ● 主程序
//---------------------------------------------------------------------------
void kernel_main() {

	arch_init ();

	idle ();
}
}
