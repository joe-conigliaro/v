fn neg(a int) int {
	return -a
}

struct FnHolder1<T> {
	func T
}

fn (self FnHolder1<T>) call(a int) int {
	return self.func(a)
}

struct FnHolder2<T> {
	func fn (int) int
}

fn (self FnHolder2<T>) call(a int) int {
	return self.func(a)
}

fn holder_call_1<T>(func T, a int) int {
	h := FnHolder1{func}
	return h.call(a)
}

fn holder_call_2<T>(func T, a int) int {
	h := FnHolder2{func}
	return h.call(a)
}

fn holder_call_11<T>(func T, a int) int {
	f := func
	h := FnHolder1{f}
	return h.call(a)
}

fn holder_call_21<T>(func T, a int) int {
	f := func
	h := FnHolder2{f}
	return h.call(a)
}

fn test_generic_struct_with_anon_fn_parameter() {
	mut ret := holder_call_1(neg, 1)
	assert ret == -1
	ret = holder_call_11(neg, 2)
	assert ret == -2

	ret = holder_call_2(neg, 3)
	assert ret == -3
	ret = holder_call_21(neg, 4)
	assert ret == -4
}