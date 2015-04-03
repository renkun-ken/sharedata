#ifndef SHAREDATA_TYPES_H_
#define SHAREDATA_TYPES_H_

#include <boost/interprocess/managed_shared_memory.hpp>
#include <boost/interprocess/containers/vector.hpp>
#include <boost/interprocess/allocators/allocator.hpp>

typedef boost::interprocess::allocator<int, boost::interprocess::managed_shared_memory::segment_manager>
  ShmemAllocator;

typedef boost::interprocess::vector<int, ShmemAllocator> SharedVector;

#endif
