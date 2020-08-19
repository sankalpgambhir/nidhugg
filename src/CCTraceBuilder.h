#ifndef __CC_TRACE_BUILDER_H__
#define __CC_TRACE_BUILDER_H__

#include "TSOTraceBuilder.h"

class CCTraceBuilder : public TSOTraceBuilder{
  public:
    CCTraceBuilder(const Configuration &conf = Configuration::default_conf) : TSOTraceBuilder(conf){};
    

    void do_load(const SymAddrSize &ml);
};

#endif