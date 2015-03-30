#Apache Mesos vs Hadoop YARN #WhiteboardWalkthrough

Hi, my name is Jim Scott,  Director of Enterprise Strategy and Architecture at MapR.

Today I'd like to talk to you in this white board walkthrough on Mesos vs YARN and why one may or may not be better and global resource management than the other. 

There is a lot of contention in these two camps between the methods and the intentions of how to use these resource managers.

* Mesos was built to be a global resource manager for your entire data center.
* YARN was created as a necessity to move the Hadoop MapReduce API to the next iteration and life cycle. 

And so it had to remove the resource management out of that embedded framework and into its own container management life cycle model if you well.

Now the primary difference between Mesos and YARN is going to be it's scheduler

so in Mesos when a job comes in, a job request comes into the Mesos
master. and what Mesos does is it determines what the resources are
then available. It makes offers back and those offers can be accepted or rejected. This allows the framework to the side what the best fit is for the job that needs to be run. 

Now if it accepts the job for the resources it places the job on slave and all is happy. It has the option to reject the offer in wait for another offer to come in.

Now one of the nice things about this model is it is very scaleable. This is a model that Google has proven that they have documented white papers are available for this that show the scalability %uh vein on
monolithic scheduling

33
00:01:59,002 --> 00:02:03,991
capacity and so what happens is when you
move over to the yarn side

34
00:02:04,189 --> 00:02:07,242
that a job request comes into the yard
Resource Manager

35
00:02:07,719 --> 00:02:11,980
yarn evaluates all the resources
available it places the job

36
00:02:11,098 --> 00:02:14,717
it's the one making the decision where
job should go

37
00:02:15,599 --> 00:02:17,800
and so thus it is modeled

38
00:02:17,008 --> 00:02:20,105
as a monolithic scheduler so from a
scaling perspective

39
00:02:21,077 --> 00:02:25,092
may sales has better scaling
capabilities now

40
00:02:25,092 --> 00:02:28,121
in addition to this yarn as I mentioned
before

41
00:02:29,021 --> 00:02:32,102
was created as a necessity for the
evolutionary step up the MapReduce

42
00:02:33,002 --> 00:02:34,005
framework

43
00:02:34,005 --> 00:02:37,101
so what this means was that yaron was
created

44
00:02:38,001 --> 00:02:41,010
to be a resource manager for Hadoop jobs

45
00:02:41,001 --> 00:02:44,060
so yarn has tried to grow out of that
and grow

46
00:02:44,069 --> 00:02:47,136
more into the space that may sell us is
occupying so well

47
00:02:48,036 --> 00:02:51,055
so in that model

48
00:02:51,055 --> 00:02:54,057
what we want to consider here is that

49
00:02:54,075 --> 00:02:57,158
we have different scaling capabilities
and that

50
00:02:58,058 --> 00:03:02,104
the implementation between these two is
going to be different and that the

51
00:03:03,004 --> 00:03:06,063
people who put these in place had
different intentions to start

52
00:03:06,063 --> 00:03:10,146
now this may makes an impact in your
decision for which to use

53
00:03:11,046 --> 00:03:16,061
so what we have here is when you want to
evaluate how to manage your datacenter

54
00:03:16,061 --> 00:03:16,068
as a whole

55
00:03:17,031 --> 00:03:21,035
you've got mesas on one side that can
manage every single resource

56
00:03:21,035 --> 00:03:24,119
in your data center and now the other
you have yard which can safely manage

57
00:03:25,019 --> 00:03:25,088
the said you

58
00:03:25,088 --> 00:03:29,145
Hadoop jobs now what that means for you
is that right now

59
00:03:30,045 --> 00:03:34,052
yarn is not capable of managing your
entire data center so

60
00:03:35,015 --> 00:03:39,041
the to have these are competing for the
space and in order for you to move along

61
00:03:39,041 --> 00:03:42,118
if you want to benefit from both this
means you'll need to create

62
00:03:43,018 --> 00:03:46,042
affectively a static the partition which
is

63
00:03:46,042 --> 00:03:50,081
so many resources will be allocated Dr
and so many resources will be allocated

64
00:03:50,459 --> 00:03:51,450
to mess us

65
00:03:51,045 --> 00:03:56,051
so fundamentally this is an issue this
is the entire

66
00:03:56,051 --> 00:04:01,066
I problem that may Sohus was designed to
prevent in the first place

67
00:04:01,066 --> 00:04:06,151
static partitioning so you probably got
a big task ahead of you to figure out

68
00:04:07,051 --> 00:04:10,250
which to use and where to use it and

69
00:04:10,709 --> 00:04:14,640
my hope is that I've given you enough
information with respect to

70
00:04:14,064 --> 00:04:17,142
resource scheduling for you to move
forward

71
00:04:18,042 --> 00:04:21,053
and ask more questions and figure out
where to move

72
00:04:21,053 --> 00:04:24,079
in your global resource management for
your datacenter now

73
00:04:24,079 --> 00:04:28,165
the question as can we make the to this
play together harmoniously

74
00:04:29,065 --> 00:04:32,204
for the sake of the benefit up the
enterprise in the data center

75
00:04:32,789 --> 00:04:36,870
so ultimately we have to ask why can't
we all just get along

76
00:04:37,599 --> 00:04:40,696
so if we put politics aside we can ask

77
00:04:41,569 --> 00:04:45,610
can we make miso sauce and yard work
together in the answer is yes

78
00:04:45,979 --> 00:04:49,400
now map are has worked in unison

79
00:04:49,004 --> 00:04:54,453
with you bay Twitter and Mesa spear to
create a project called Project married

80
00:04:54,849 --> 00:04:58,900
now project marian's goal is to actually
make the to these work together

81
00:04:58,009 --> 00:05:02,928
what that means is may sell us can
manage your entire data center

82
00:05:03,819 --> 00:05:07,825
with this open source software it
enables may source

83
00:05:08,419 --> 00:05:11,550
myriad executors to

84
00:05:11,055 --> 00:05:14,078
launch in manage yarn node managers

85
00:05:14,078 --> 00:05:17,083
what happens is that

86
00:05:17,083 --> 00:05:20,922
when a job comes n 2-yard

87
00:05:21,669 --> 00:05:24,743
it will send the request to Mesa house

88
00:05:25,409 --> 00:05:28,840
mesas in turn will pass it on to with
the Mesa slave

89
00:05:28,084 --> 00:05:31,102
and then there's a myriad executor that
runs

90
00:05:32,002 --> 00:05:35,037
near the yarn owed manager in the Mesa
slave

91
00:05:35,037 --> 00:05:38,176
and what it does is it advertises to

92
00:05:38,509 --> 00:05:41,900
the yarn node manager how many resources
it has available

93
00:05:41,009 --> 00:05:45,075
now the beauty of this approach is this
actually makes yard

94
00:05:46,056 --> 00:05:51,056
more dynamic because it gives the
resources to yarn

95
00:05:51,056 --> 00:05:54,080
that it wants to place where it sees fit

96
00:05:54,008 --> 00:05:58,867
and so from the May so side if you want
to add or remove resources from yard it

97
00:05:59,659 --> 00:06:01,757
becomes very easy to dynamically control
your entire data center

98
00:06:02,639 --> 00:06:06,697
the benefit here is that when you have
your production operations being managed

99
00:06:07,219 --> 00:06:11,286
globally by mass else you can have the
people on the data analytic side

100
00:06:11,889 --> 00:06:14,916
running their jobs in any fashion that
they see fit

101
00:06:15,159 --> 00:06:21,860
via yarn for job placement this means
that dynamically

102
00:06:21,086 --> 00:06:24,945
darn will be limited in a production
environment and

103
00:06:25,719 --> 00:06:29,000
from a global perspective if you need to
take resources away

104
00:06:29,000 --> 00:06:32,063
a douche resiliency with job placement
will allow those jobs to be placed

105
00:06:32,063 --> 00:06:32,144
elsewhere

106
00:06:33,044 --> 00:06:37,133
on the cluster you can kill instances of
yarn

107
00:06:37,529 --> 00:06:42,130
and take back those resources to make
them available two missiles

108
00:06:42,013 --> 00:06:45,067
this really is the best of both worlds
it removes the static partitioning

109
00:06:45,067 --> 00:06:47,114
concept that running the two with these

110
00:06:48,014 --> 00:06:52,031
independently in the and a data center
would create

111
00:06:52,031 --> 00:06:57,039
so the benefit overall is that project
Mary it is going to enable you

112
00:06:57,039 --> 00:07:00,055
to deploy both technologies in your data
center

113
00:07:00,055 --> 00:07:03,151
leverage this for your data center
resource management as a whole

114
00:07:04,051 --> 00:07:07,143
leverage this to manage those Hadoop
jobs where you may need them to just get

115
00:07:08,043 --> 00:07:09,049
deployed faster

116
00:07:09,049 --> 00:07:14,065
where you don't care about the accept
and reject capabilities that may sales

117
00:07:14,065 --> 00:07:14,163
for those jobs

118
00:07:15,063 --> 00:07:18,077
where data locality is your primary
concern

119
00:07:18,077 --> 00:07:22,101
for Hadoop data only this is an enabling
technology

120
00:07:23,001 --> 00:07:28,035
that we hope that you will look into and
evaluate if it's a fit for your company

121
00:07:28,035 --> 00:07:32,047
project Mary it is hosted on github and
is available for download

122
00:07:32,047 --> 00:07:35,047
there's documentation there that
explains how this works you probably

123
00:07:35,047 --> 00:07:37,058
even see diagram similar to this but

124
00:07:37,058 --> 00:07:41,063
while probably little prettier so go out
explore

125
00:07:41,063 --> 00:07:44,119
and give it a try that's all for this
way toward walkthrough

126
00:07:45,019 --> 00:07:48,062
of missiles purses are if you have any
questions

127
00:07:48,062 --> 00:07:52,079
about this topic map are is the open
source leader for May so some yard

128
00:07:52,079 --> 00:07:55,708
please feel free to contact us and asks
any questions on how to implement this

129
00:07:56,419 --> 00:07:57,370
in your business

130
00:07:57,037 --> 00:08:02,066
and remember if you've like this and
you'd like to suggest more topics please

131
00:08:02,066 --> 00:08:03,080
comment below

132
00:08:03,008 --> 00:08:06,073
and don't forget to follow us on Twitter
at map are

133
00:08:07,045 --> 00:08:09,106
hash tag whitewater thank you


