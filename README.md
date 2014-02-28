Welcome to a Barclamp for the Crowbar Framework project
=======================================================
_Copyright 2011, Dell, Inc._

The code and documentation is distributed under the Apache 2 license (http://www.apache.org/licenses/LICENSE-2.0.html). Contributions back to the source are encouraged.

The Crowbar Framework (https://github.com/dellcloudedge/crowbar) was developed by the Dell CloudEdge Solutions Team (http://dell.com/openstack) as a OpenStack installer (http://OpenStack.org) but has evolved as a much broader function tool. 
A Barclamp is a module component that implements functionality for Crowbar.  Core barclamps operate the essential functions of the Crowbar deployment mechanics while other barclamps extend the system for specific applications.

* This functonality of this barclamp DOES NOT stand alone, the Crowbar Framework is required * 

About this Barclamp-keystone
-------------------------------------

Information for this barclamp is maintained on the Crowbar Framework Wiki: https://github.com/dellcloudedge/crowbar/wiki

This is based on OpenStack.org distribution

This barclamp is designed to be used in conjunction with the OpenStack High-Availability barclamps please review the https://github.com/crowbar/barclamp-openstack-titanium-loadbalancer for deployment information.

This barclamp should be applued to  3 controller nodes.

Run the script setup.sh before installing Glance barclamp
Change setup.sh permissions to execute setup.sh first
It will download cloud image archive from ubuntu website

Images synchronization (file storage) accross all Glance nodes is  done with cron jobs.
Cron jobs are run every 2 minutes 
Images synchronization  accross all nodes has a maximum delay of: 2 minutes + images upload duration

glance/cache/files/ami/ubuntu-12.04-server-cloudimg-amd64.tar.gz is missing in the Git repository due to Github file size limitation


Legals
-------------------------------------
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

