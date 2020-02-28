//boot jack server first, then evaluate the following
(
var options, bsa=64, bsb=64, bsc=64, bsd=64;

options= ServerOptions.new;
options.blockSize = bsa;
options.inDevice ="JackRouter";
options.outDevice ="JackRouter";
options.numInputBusChannels= 1;
options.numOutputBusChannels= 24;

s= Server(\s_proxy, NetAddr("127.0.0.1", 57111), options);

s.waitForBoot({
	options.blockSize = bsb;
	options.inDevice ="JackRouter";
	options.outDevice ="JackRouter";
	options.numInputBusChannels= 24;
	options.numOutputBusChannels= 24;
	options.memSize = 8192 * 32 * 20;
	t= Server(\t_jpverb, NetAddr("127.0.0.1", 57112), options);

	t.waitForBoot({
		options.blockSize = bsc;
		options.inDevice ="JackRouter";
		options.outDevice ="JackRouter";
		options.numInputBusChannels= 24;
		options.numOutputBusChannels= 24;
		options.memSize = 8192 * 32 * 20;
		u= Server(\u_jpverb, NetAddr("127.0.0.1", 57113), options);

		u.waitForBoot({
			options.blockSize = bsd;
			options.inDevice ="JackRouter";
			options.outDevice ="JackRouter";
			options.numInputBusChannels= 24;
			options.numOutputBusChannels= 24;
			options.memSize = 8192 * 32 * 20;
			v= Server(\v_jpverb, NetAddr("127.0.0.1", 57114), options);

			v.waitForBoot({
				options.blockSize = bsd;
				options.inDevice ="JackRouter";
				options.outDevice ="JackRouter";
				options.numInputBusChannels= 24;
				options.numOutputBusChannels= 24;
				options.memSize = 8192 * 32 * 20;
				w= Server(\w_jpverb, NetAddr("127.0.0.1", 57115), options);

				w.waitForBoot({
					MeterView.new(s, 1, 24, 0, 0);
					MeterView.new(t, 6, 24, 0, 0);
					MeterView.new(u, 6, 24, 0, 0);
					MeterView.new(v, 6, 24, 0, 0);
					MeterView.new(w, 6, 24, 0, 0);
					Server.default = s;
				})
			})
		})
	})
});
)
//load the 5 servers patch in jp
//in JackPilot : file>>load studio setup>>Users/Daniele/Desktop/almat/opencube/installation/rk_2servers.jks

Task({NoiseTest(24, -50, 0.2, 0.1, server:s)}).play;
